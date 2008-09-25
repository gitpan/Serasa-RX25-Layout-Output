#!/usr/bin/perl

# Copyright (c) 2008 Aware TI.
# Copyright (c) 2008 Thiago Rondon <thiago@aware.com.br>

use strict;

use Serasa::RX25::Layout::Output;

&main();
sub main() {

	my $serasa = new Serasa::RX25::Layout::Output;

	$serasa->username("12345678");
	$serasa->password("1234    ");
	$serasa->cnpj_solicitante("111111111111");

	$serasa->tipo_documento('F');
	$serasa->documento('2222222222');

	$serasa->send();
	if ($serasa->is_success) {
		print $serasa->content() . "\n";
	}

}

1;

