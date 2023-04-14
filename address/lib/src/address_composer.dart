import 'package:flutter/material.dart';

import './address_page.dart';

abstract class AddressComposer {
  static Widget composeAddressPage(){
    return AddressPage();
  }
}
