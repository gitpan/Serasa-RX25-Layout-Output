#!/usr/bin/perl

package Serasa::RX25::Layout::Output;

use strict;
use warnings;

use vars qw($VERSION);
use Carp;

use LWP::UserAgent;
use HTTP::Request;

$VERSION = "0.01";

use constant SPACE => ' ';

sub new () {
        my ($class, %params) = @_;
	my $self = {};
	bless $self, $class;
	$self->_init(%params) or return undef;
	return $self;
}

sub username {
	my $self = shift;
	if (@_) { $self->{"_username"} = shift }
	return $self->{"_username"};
}

sub password {
	my $self = shift;
	if (@_) { $self->{"_password"} = shift }
	return $self->{"_password"};
}

sub baseurl {
        my $self = shift;
	if (@_) { $self->{"_baseurl"} = shift }
	return $self->{"_baseurl"};
}

sub is_success {
	my $self = shift;
	return $self->{"_success"};
}

sub content {
        my $self = shift;
	if (@_) { $self->{"_content"} = shift }
	return $self->{"_content"};
}

sub tipo_documento {
        my $self = shift;
	if (@_) { $self->{"_tipo_documento"} = shift }
	return $self->{"_tipo_documento"};
}

sub documento {
        my $self = shift;
	if (@_) { $self->{"_documento"} = shift }
	return $self->{"_documento"};
}


sub banco {
        my $self = shift;
	if (@_) { $self->{"_banco"} = shift }
	return $self->{"_banco"};
}

sub agencia {
        my $self = shift;
	if (@_) { $self->{"_agencia"} = shift }
	return $self->{"_agencia"};
}

sub conta_corrente {
        my $self = shift;
	if (@_) { $self->{"_conta_corrente"} = shift }
	return $self->{"_banco"};
}

sub cheque_inicial {
        my $self = shift;
	if (@_) { $self->{"_cheque_inicial"} = shift }
	return $self->{"_banco"};
}

sub cheque_final {
        my $self = shift;
	if (@_) { $self->{"_cheque_final"} = shift }
	return $self->{"_cheque_final"};
}

sub cheque_valor {
        my $self = shift;
	if (@_) { $self->{"_cheque_valor"} = shift }
	return $self->{"_cheque_valor"};
}

sub data_vencimento {
        my $self = shift;
	if (@_) { $self->{"_data_vencimento"} = shift }
	return $self->{"_data_vencimento"};
}

sub ddd {
        my $self = shift;
	if (@_) { $self->{"_ddd"} = shift }
	return $self->{"_ddd"};
}

sub cnpj_solicitante {
        my $self = shift;
	if (@_) { $self->{"_cnpj_solicitante"} = shift }
	return $self->{"_cnpj_solicitante"};
}

sub telefone {
        my $self = shift;
	if (@_) { $self->{"_telefone"} = shift }
	return $self->{"_telefone"};
}

sub cep {
        my $self = shift;
	if (@_) { $self->{"_cep"} = shift }
	return $self->{"_cep"};
}

sub _format_string() {
	my ($self, $string, $len, $left) = @_;
	my ($ret, $letter);

	return '' if !$string;
	$letter = length($string) ? "0" : " ";
	$string = substr($string, 0, $len);

	if ($left) {
		$ret = $letter x ($len - length($string)) . $string;
	} else {
		$ret = $string . $letter x ($len - length($string));
	}

	return $ret;
}


sub send () {
	my $self = shift;

	foreach(qw/username password/) {
		$self->_croak("$_ not specified.") unless(defined $self->{"_$_"});
	}
	my $query = $self->_get_query();

        my $response = $self->{"_ua"}->post($self->baseurl,
	                [ 'p' => $query ]
	);

        if ($response->is_success()) {
		$self->{"_content"} = $response->content;
		$self->{"_success"} = 1;
	} else {
		$self->{"_success"} = 0;
	}
	
	return $self->is_success;
}

sub _get_query() {
	my $self = shift;

	my $tipo_documento = substr($self->tipo_documento, 0, 1);
	my $documento = $self->_format_string($self->documento, 15, 1);
	my $banco = $self->_format_string($self->banco, 3, 1);
	my $agencia = $self->_format_string($self->agencia, 4, 1);
	my $conta_corrente = $self->_format_string($self->conta_corrente, 15, 1);
	my $cheque_inicial = $self->_format_string($self->cheque_inicial, 7, 1);
	my $cheque_final = $self->_format_string($self->cheque_final, 7, 1);
	my $cheque_valor = $self->_format_string($self->cheque_valor, 15, 1);
	my $data_vencimento = $self->_format_string($self->data_vencimento, 8);
	my $ddd = $self->_format_string($self->ddd, 4, 1);
	my $telefone = $self->_format_string($self->telefone, 8);
	my $cep = $self->_format_string($self->cep, 9);

	my $query;

	# Inicial
	$query .= $self->{_username};
	$query .= $self->{_password};
	$query .= SPACE x 8;

	# Codigo da transacao
	$query .= "RE01";

	# Codigo da transacao contrada
	$query .= "RX25";

	# Codigo da Release
	$query .= "VERSAO-02.00";
	$query .= "0" x 16;

	# CNPJ da solicitante da Consulta.
	$query .= $self->{_cnpj_solicitante};

	# Codigo da Estacao
	$query .= "000001";

	# Meio de Acesso
	$query .= "1";

	# Funcao de chamada
	$query .= SPACE x 4;

	# Area reservada (serasa)
	$query .= SPACE x 30;

	# Tipo de documento (F ou J)
	$query .= $tipo_documento;

	# Documento de pesquisa (CNPJ/CPF);
	$query .= $documento;

	# Opcao de consulta
	$query .= "CH";

	# Identificacao dos dados do cheque ( 1= banco+agencia+cc+cheques)
	$query .= "1";

	# Banco
	$query .= $banco;

	# Numero da agencia
	$query .= $agencia;

	# Conta Corrente
	$query .= $conta_corrente;

	# Numero e Digito do cheque inicial
	$query .= $cheque_inicial;

	# Numero e Digito do cheque Final
	$query .= $cheque_final;

	# CMC7 inicial 
	$query .= SPACE x 30;

	# CMC7 Final
	$query .= SPACE x 30;

	# Valor do cheque
	$query .= $cheque_valor;

	# Data do vencimento
	$query .= $data_vencimento;

	# Numero do DDD
	$query .= $ddd;

	# Numero do telefone
	$query .= $telefone;

	# CEP
	$query .= $cep;

	# Reservado
	$query .= SPACE x 48;

	# Enceramento
	$query .= "X";

	return $query;
}


sub _init {
	my $self = shift;

	my $ua =  LWP::UserAgent->new(
		agent => __PACKAGE__." v. $VERSION",
	);


	my %options = (
		ua                => $ua,
		baseurl           => 'https://sitenet07.serasa.com.br/Prod/consultahttps',
		username          => undef,
		password	  => undef,
		cnpj_solicitante  => undef,
		success           => undef,
		tipo_documento	  => 'F',
		documento	  => undef,
		banco		  => undef,
		agencia		  => undef,
		conta_corrente	  => undef,
		cheque_inicial    => undef,
		cheque_valor	  => undef,
		data_vencimento   => undef,
		ddd		  => undef,
		telefone 	  => undef,
		cep		  => undef,
        );

	$self->{"_$_"} = $options{$_} foreach(keys %options);
	return $self;
}

sub _croak {
	my ($self, @error) = @_;
	Carp::croak(@error);
}


1;

=head1 NAME

Serasa::RX25::Layout::Output - Layout of output string to send for Serasa.

=head1 SYNOPISIS

        use Serasa::RX25::Layout::Output;

	my $serasa = new Serasa::RX25::Layout::Output;
	$serasa->username('12345678');
	$serasa->password('2345    ');
	$serasa->cnpj_solicitante('000000000000');

	$serasa->tipo_documento('F');
	$serasa->documento('000000000');
	$serasa->agencia('1234');
	$serasa->banco('123');
	$serasa->conta_corrente('12341');
	$serasa->cheque_inicial('12');
	$serasa->cheque_final('23');
	$serasa->data_vencimento('55');
	$serasa->ddd('011');
	$serasa->telefone('23441234');
	$serasa->cep('12345123');

	$serasa->send("message");
	if ($serasa->is_success) {
		print $serasa->content;
	}

=head1 DESCRIPTION

Serasa::RX25::Layout::Output - Helper for send output string for Serasa.

=head1 AUTHOR

Thiago Rondon, E<lt>thiago@aware.com.brE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Thiago Rondon

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut

