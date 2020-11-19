//  Created by Navpreet on 12/12/18.
//  Copyright © 2018 Navpreet. All rights reserved.

import Foundation
import UIKit
import Stripe

extension UIViewController: AddressDelegate, AddressDismissDelegate, AddCardPaymentMethodDelegate, CardPaymentDismissDelegate, ThankYouScreenDelegate, ShowProductDetailDelegate, ProductDetailDismissDelegate {

    //MARK:- Show add shipping address view
    func addShippingAddress(checkoutPreferences: CheckoutProtocolModel?) {
        self.moveToShippingAddressVC(isAddAddress: true, checkoutPreferences: checkoutPreferences)
    }
    func addBillingAddress(checkoutPreferences: CheckoutProtocolModel?) {
        self.moveToBillingAddressVC(checkoutPreferences: checkoutPreferences)
    }
    //MARK:- Show edit shipping address view
    
    func editShippingAddress(checkoutPreferences: CheckoutProtocolModel?) {
        self.moveToShippingAddressVC(isAddAddress: false, checkoutPreferences: checkoutPreferences)
    }
    //MARK:- Show add new card view
    func addPaymentMethod(checkoutPreferences: CheckoutProtocolModel?) {
        self.moveToAddNewCardDetailsVC(checkoutPreferences: checkoutPreferences)
    }
    //MARK:- Show Thank You Screen
    func navigateToThankYouVC() {
        self.moveToThankYouScreen()
    }
    
    //MARK:- Show Product Detail Screen
    
    func navigateToProductDetailVC(product: Product, isShowCartButtons: Bool, checkoutPreferences: CheckoutProtocolModel?) {
        self.moveToProductDetailScreen(product: product, isShowCartButtons: isShowCartButtons, checkoutPreferences: checkoutPreferences)
    }
    //MARK:- Move to checkout screen after current view controller is dismissed
    func shippingAddressViewDismissed(checkoutPreferences: CheckoutProtocolModel?) {
        self.moveToCheckoutScreen(checkoutPreferences: checkoutPreferences)
    }
    func billingAddressViewDismissed(checkoutPreferences: CheckoutProtocolModel?) {
        self.moveToCheckoutScreen(checkoutPreferences: checkoutPreferences)
    }
    func cardPaymentViewDismissed(checkoutPreferences: CheckoutProtocolModel?) {
        self.moveToCheckoutScreen(checkoutPreferences: checkoutPreferences)
    }
    func productDetailViewDismissed(checkoutPreferences: CheckoutProtocolModel?) {
        self.moveToCheckoutScreen(checkoutPreferences: checkoutPreferences)
    }
    //MARK:- Move to shipping address view controller
    func moveToShippingAddressVC(isAddAddress: Bool, checkoutPreferences: CheckoutProtocolModel?) {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ShippingAddressVC") as! ShippingAddressVC
        vcObj.isAddAddress = isAddAddress
        vcObj.isShippingAddress = true
        vcObj.checkoutPreferences = checkoutPreferences
        vcObj.addressDismissDelegate = self
        self.modalPresentationStyle = .overFullScreen
        self.present(vcObj, animated: true, completion: nil)
    }
    func moveToBillingAddressVC(checkoutPreferences: CheckoutProtocolModel?) {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ShippingAddressVC") as! ShippingAddressVC
        vcObj.isShippingAddress = false
        vcObj.isShippingAddress = false
        vcObj.checkoutPreferences = checkoutPreferences
        vcObj.addressDismissDelegate = self
        self.modalPresentationStyle = .overFullScreen
        self.present(vcObj, animated: true, completion: nil)
    }
    
    //MARK:- Move to add new card view controller
    func moveToAddNewCardDetailsVC(checkoutPreferences: CheckoutProtocolModel?) {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "CardPaymentVC") as! CardPaymentVC
        vcObj.checkoutPreferences = checkoutPreferences
        vcObj.cardPaymentDismissDelegate = self
        self.modalPresentationStyle = .overFullScreen
        self.present(vcObj, animated: true, completion: nil)
    }
    
    //MARK:- Move to checkout view controller
    func moveToCheckoutScreen(checkoutPreferences: CheckoutProtocolModel?) {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "CheckoutVC") as! CheckoutVC
        vcObj.checkoutPreferences = checkoutPreferences
        vcObj.addressDelegate = self
        vcObj.paymentMethodDelegate = self
        vcObj.thankYouScreenDelegate = self
        vcObj.showProductDetailDelegate = self
        self.modalPresentationStyle = .overFullScreen
        self.present(vcObj, animated: true, completion: nil)
    }
    func moveToProductDetailScreen(product: Product, isShowCartButtons: Bool, checkoutPreferences: CheckoutProtocolModel?) {
        let storyboard = UIStoryboard(name: "ProjectStoryboard", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        vcObj.product = product
        vcObj.isShowCartButtons = isShowCartButtons
        vcObj.checkoutPreferences = checkoutPreferences
        vcObj.productDetailDismissDelegate = self
        vcObj.modalPresentationStyle = .overFullScreen
        self.present(vcObj, animated: true, completion: nil)
    }
    //MARK:- Move to thank yoy view controller
    func moveToThankYouScreen() {
        NOTIFICATIONCENTER.post(name: Notification.Name("pauseVideo"), object: nil)
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        let vcObj = storyboard.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
        self.modalPresentationStyle = .overFullScreen
        self.present(vcObj, animated: true, completion: nil)
    }
}
