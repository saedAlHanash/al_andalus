import 'package:al_andalus/core/extensions/extensions.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:string_similarity/string_similarity.dart';

import '../../features/cars/data/response/cars_response.dart';
import '../../generated/assets.dart';
import '../../generated/l10n.dart';
import 'app_color_manager.dart';

enum StartPage { login, home, signupOtp, pinCode, passwordOtp }

enum GenderEnum {
  male,
  female;

  String get name {
    switch (this) {
      case GenderEnum.male:
        return 'ذكر';
      case GenderEnum.female:
        return 'أنثى';
    }
  }

  String get nameApi {
    switch (this) {
      case GenderEnum.male:
        return 'male';
      case GenderEnum.female:
        return 'female';
    }
  }
}

enum LicenseType {
  public,
  private,
  //public / private
  ;

  String get name {
    switch (this) {
      case LicenseType.public:
        return S().public;
      case LicenseType.private:
        return S().private;
    }
  }

  String get nameApi {
    switch (this) {
      case LicenseType.public:
        return 'public';
      case LicenseType.private:
        return 'private';
    }
  }
}

enum IraqGovernorate {
  baghdad,
  basra,
  nineveh,
  erbil,
  sulaymaniyah,
  dhiQar,
  anbar,
  najaf,
  karbala,
  diyala,
  muthanna,
  salahaddin,
  babil,
  kirkuk,
  wasit,
  dahuk,
  diwaniyah,
  maysan;

  String get name {
    switch (this) {
      case IraqGovernorate.baghdad:
        return 'بغداد';
      case IraqGovernorate.basra:
        return 'البصرة';
      case IraqGovernorate.nineveh:
        return 'نينوى';
      case IraqGovernorate.erbil:
        return 'أربيل';
      case IraqGovernorate.sulaymaniyah:
        return 'السليمانية';
      case IraqGovernorate.dhiQar:
        return 'ذي قار';
      case IraqGovernorate.anbar:
        return 'الأنبار';
      case IraqGovernorate.najaf:
        return 'النجف';
      case IraqGovernorate.karbala:
        return 'كربلاء';
      case IraqGovernorate.diyala:
        return 'ديالى';
      case IraqGovernorate.muthanna:
        return 'المثنى';
      case IraqGovernorate.salahaddin:
        return 'صلاح الدين';
      case IraqGovernorate.babil:
        return 'بابل';
      case IraqGovernorate.kirkuk:
        return 'كركوك';
      case IraqGovernorate.wasit:
        return 'واسط';
      case IraqGovernorate.dahuk:
        return 'دهوك';
      case IraqGovernorate.diwaniyah:
        return 'الديوانية';
      case IraqGovernorate.maysan:
        return 'ميسان';
    }
  }

  static IraqGovernorate getByName(String name) {
    return IraqGovernorate.values.firstWhere(
      (g) => g.name == name,
      orElse: () => IraqGovernorate.baghdad,
    );
  }

  static IraqGovernorate getByApproximateName(String inputName) {
    inputName = inputName.trim();

    IraqGovernorate? bestMatch;
    double bestScore = 0;

    for (final gov in IraqGovernorate.values) {
      final score = StringSimilarity.compareTwoStrings(inputName, gov.name);
      if (score > bestScore) {
        bestScore = score;
        bestMatch = gov;
      }
    }

    // حدد الحد الأدنى لقبول التشابه (مثلاً 0.6)
    if (bestScore >= 0.6 && bestMatch != null) {
      return bestMatch;
    }

    return IraqGovernorate.baghdad;
  }
}

enum ApiType {
  get,
  post,
  put,
  patch,
  delete,
}

enum GetProductsType { non, topSell, latest, offers }

enum SortBy {
  price,
  createdAt;

  String get name {
    switch (this) {
      case SortBy.price:
        return S().price;
      case SortBy.createdAt:
        return S().latest;
    }
  }

  String get nameApi {
    switch (this) {
      case SortBy.price:
        return 'price';
      case SortBy.createdAt:
        return 'created_at';
    }
  }
}

enum SortOrder {
  asc,
  desc;

  String get name {
    switch (this) {
      case SortOrder.asc:
        return S().ascending;
      case SortOrder.desc:
        return S().descending;
    }
  }

  String get nameApi {
    switch (this) {
      case SortOrder.asc:
        return 'asc';
      case SortOrder.desc:
        return 'desc';
    }
  }
}

enum FontManager { regular, semeBold, bold }

enum CouponType {
  fixed,
  percentage;

  static CouponType getByNameOrIndex(String name) {
    final i = int.tryParse(name);
    if (i != null) return CouponType.values[i];
    switch (name.toLowerCase()) {
      case 'fixed':
        return CouponType.fixed;
      case 'percentage':
        return CouponType.percentage;
      default:
        return CouponType.fixed;
    }
  }
}

enum OrderStatus {
  pending,
  accepted,
  completed,
  cancelled,
  returned,
  needPay,
  ;

  Color get color {
    switch (this) {
      case OrderStatus.pending:
      case OrderStatus.accepted:
        return AppColorManager.mainColor;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
      case OrderStatus.returned:
        return Colors.red;
      case OrderStatus.needPay:
        return Colors.grey;
    }
  }

  String get name {
    //S()
    return switch (this) {
      OrderStatus.pending => S().pending,
      OrderStatus.accepted => S().accepted,
      OrderStatus.completed => S().completed,
      OrderStatus.cancelled => S().cancelled,
      OrderStatus.returned => S().returned,
      OrderStatus.needPay => S().needPay,
    };
  }

  static OrderStatus getByNameOrIndex(String name) {
    final i = int.tryParse(name);
    if (i != null) {
      return OrderStatus.values[i];
    }
    return switch (name.toLowerCase()) {
      'pending' => OrderStatus.pending,
      'accepted' => OrderStatus.accepted,
      'completed' => OrderStatus.completed,
      'cancelled' => OrderStatus.cancelled,
      'returned' => OrderStatus.returned,
      'need_pay' => OrderStatus.needPay,
      _ => OrderStatus.pending,
    };
  }
}

enum AdsType {
  banner,
  slider;

  Color get getOrderStateColorText {
    switch (this) {
      case AdsType.banner:
      case AdsType.slider:
        return AppColorManager.mainColor;
    }
  }

  static AdsType getByNameOrIndex(dynamic name) {
    return switch (name.toLowerCase()) {
      'banner' => AdsType.slider,
      'slider' => AdsType.banner,
      _ => AdsType.slider,
    };
  }
}

enum CompressQuality {
  q20,
  q40,
  q60,
  q80,
  q100;

  int get getQuality {
    switch (this) {
      case CompressQuality.q20:
        return 20;
      case CompressQuality.q40:
        return 40;
      case CompressQuality.q60:
        return 60;
      case CompressQuality.q80:
        return 80;
      case CompressQuality.q100:
        return 100;
    }
  }
}

enum FileType {
  image,
  video,
  audio,
  pdf,
  document,
  other;

  IconData get fileTypeIcon {
    switch (this) {
      case FileType.image:
        return Icons.image_rounded;
      case FileType.video:
        return Icons.videocam_rounded;
      case FileType.audio:
        return Icons.audiotrack_rounded;
      case FileType.pdf:
        return Icons.picture_as_pdf_rounded;
      case FileType.document:
        return Icons.description_rounded;
      case FileType.other:
        return Icons.insert_drive_file_rounded;
    }
  }
}

enum DataPageType {
  policy,
  terms,
  aboutUs,
  ourService,
  ;

  String get name {
    switch (this) {
      case DataPageType.policy:
        return S().policy;
      case DataPageType.terms:
        return S().termsAndConditions;
      case DataPageType.aboutUs:
        return S().aboutUs;
      case DataPageType.ourService:
        return S().ourService;
    }
  }
}

enum InsuranceType {
  private,
  public,
  ;

  Widget get icon {
    switch (this) {
      case .private:
        return ImageMultiType(url: Icons.person_outline_rounded, color: color);
      case .public:
        return ImageMultiType(url: Icons.business_center_outlined, color: color);
    }
  }

  Color get color {
    switch (this) {
      case .private:
        return AppColorManager.c8f;
      case .public:
        return Colors.blue;
    }
  }

  String get name {
    switch (this) {
      case .private:
        return S().private;
      case .public:
        return S().public;
    }
  }

  String get note {
    switch (this) {
      case .private:
        return S().privateInsuranceNote;
      case .public:
        return S().vehiclesDesignedForCommercialUseOrTransportingPeopleOrGoods;
    }
  }

  String get nameApi {
    switch (this) {
      case .private:
        return 'private';
      case .public:
        return 'public';
    }
  }

  static InsuranceType getByNameOrIndex(dynamic name) {
    final i = int.tryParse(name.toString());
    if (i != null) {
      return .values[i];
    }
    switch (name.toString().toLowerCase()) {
      case 'private':
        return .private;
      case 'public':
        return .public;
      default:
        return .private;
    }
  }
}

enum InsuranceLevel {
  platinum,
  gold,
  silver,
  ;

  static InsuranceLevel getByNameOrIndex(dynamic name) {
    final i = int.tryParse(name.toString());
    if (i != null) {
      return InsuranceLevel.values[i];
    }
    switch (name.toString().toLowerCase()) {
      case 'silver':
        return InsuranceLevel.silver;
      case 'platinum':
        return InsuranceLevel.platinum;
      case 'gold':
        return InsuranceLevel.gold;
      default:
        return InsuranceLevel.silver;
    }
  }

  Color get color {
    switch (this) {
      case InsuranceLevel.platinum:
        return const Color(0xFFA0B2C6); // لون البلاتينيوم (رمادي فاتح جداً)
      case InsuranceLevel.gold:
        return const Color(0xFFE8C352); // اللون الذهبي
      case InsuranceLevel.silver:
        return const Color(0xFFC4C4C4); // اللون الفضي
    }
  }

  List<Color> get gradient {
    switch (this) {
      case InsuranceLevel.platinum:
        return [const Color(0xFFA0B2C6), const Color(0xFFA0B2C6).withValues(alpha: 0.5)];
      case InsuranceLevel.gold:
        return [const Color(0xFFE8C352), const Color(0xFFE8C352).withValues(alpha: 0.5)];
      case InsuranceLevel.silver:
        return [const Color(0xFFC4C4C4), const Color(0xFFC4C4C4).withValues(alpha: 0.5)];
    }
  }
}

enum PricingType {
  fixed,
  percent,
  ;

  static PricingType getByNameOrIndex(String name) {
    switch (name.toLowerCase()) {
      case 'fixed':
        return PricingType.fixed;
      case 'percent':
        return PricingType.percent;
      default:
        return PricingType.fixed;
    }
  }
}

enum FuelType {
  petrol,
  hybrid,
  gaz,
  ;

  String get name {
    switch (this) {
      case FuelType.petrol:
        return S().petrol;
      case FuelType.hybrid:
        return S().hybrid;
      case FuelType.gaz:
        return S().gaz;
    }
  }

  String get nameApi {
    switch (this) {
      case FuelType.petrol:
        return 'petrol';
      case FuelType.hybrid:
        return 'hybrid';
      case FuelType.gaz:
        return 'gaz';
    }
  }

  static FuelType getByNameOrIndex(dynamic name) {
    final i = int.tryParse(name.toString());
    if (i != null) {
      return FuelType.values[i];
    }
    switch (name.toString().toLowerCase()) {
      case 'petrol':
        return FuelType.petrol;
      case 'hybrid':
        return FuelType.hybrid;
      case 'gaz':
        return FuelType.gaz;
      default:
        return FuelType.petrol;
    }
  }
}

enum InspectionStatus {
  intact,
  damage,
  missing,
  ;

  String get name {
    switch (this) {
      case InspectionStatus.intact:
        return S().intact;
      case InspectionStatus.damage:
        return S().damage;
      case InspectionStatus.missing:
        return S().missing;
    }
  }

  String get nameApi {
    switch (this) {
      case InspectionStatus.intact:
        return 'intact';
      case InspectionStatus.damage:
        return 'damage';
      case InspectionStatus.missing:
        return 'missing';
    }
  }

  static InspectionStatus getByNameOrIndex(dynamic name) {
    final i = int.tryParse(name.toString());
    if (i != null) {
      return InspectionStatus.values[i];
    }
    switch (name.toString().toLowerCase()) {
      case 'intact':
        return InspectionStatus.intact;
      case 'damage':
        return InspectionStatus.damage;
      case 'missing':
        return InspectionStatus.missing;
      default:
        return InspectionStatus.intact;
    }
  }
}

enum CarStatus {
  intact,
  damage,
  missing,
  ;

  String get name {
    switch (this) {
      case CarStatus.intact:
        return S().intact;
      case CarStatus.damage:
        return S().damage;
      case CarStatus.missing:
        return S().missing;
    }
  }

  String get nameApi {
    switch (this) {
      case CarStatus.intact:
        return 'intact';
      case CarStatus.damage:
        return 'damage';
      case CarStatus.missing:
        return 'missing';
    }
  }

  static CarStatus getByNameOrIndex(dynamic name) {
    final i = int.tryParse(name.toString());
    if (i != null) {
      return CarStatus.values[i];
    }
    switch (name.toString().toLowerCase()) {
      case 'intact':
        return CarStatus.intact;
      case 'damage':
        return CarStatus.damage;
      case 'missing':
        return CarStatus.missing;
      default:
        return CarStatus.intact;
    }
  }
}

enum ImageZone {
  front,
  engine,
  right,
  left,
  interior,
  rear,
  ;

  String get name {
    switch (this) {
      case ImageZone.front:
        return S().front;
      case ImageZone.engine:
        return S().engine;
      case ImageZone.right:
        return S().right;
      case ImageZone.left:
        return S().left;
      case ImageZone.interior:
        return S().interior;
      case ImageZone.rear:
        return S().rear;
    }
  }

  String get nameApi {
    switch (this) {
      case ImageZone.front:
        return 'front';
      case ImageZone.engine:
        return 'engine';
      case ImageZone.right:
        return 'right';
      case ImageZone.left:
        return 'left';
      case ImageZone.interior:
        return 'interior';
      case ImageZone.rear:
        return 'rear';
    }
  }

  static ImageZone getByNameOrIndex(dynamic name) {
    final i = int.tryParse(name.toString());
    if (i != null) {
      return ImageZone.values[i];
    }
    switch (name.toString().toLowerCase()) {
      case 'front':
        return ImageZone.front;
      case 'engine':
        return ImageZone.engine;
      case 'right':
        return ImageZone.right;
      case 'left':
        return ImageZone.left;
      case 'interior':
        return ImageZone.interior;
      case 'rear':
        return ImageZone.rear;
      default:
        return ImageZone.front;
    }
  }
}

enum PaymentType {
  zainCash,
  qiCard,
  ;

  String get name {
    switch (this) {
      case PaymentType.zainCash:
        return S().zainCash;
      case PaymentType.qiCard:
        return S().qiCard;
    }
  }

  String get nameApi {
    switch (this) {
      case PaymentType.zainCash:
        return 'zain_cash';
      case PaymentType.qiCard:
        return 'qi_card';
    }
  }

  Widget get icon {
    switch (this) {
      case PaymentType.zainCash:
        return ImageMultiType(
          url: Assets.images.zainCash.path,
          width: 71.0.w,
        );
      case PaymentType.qiCard:
        return ImageMultiType(
          url: Assets.images.visa.path,
          width: 71.0.w,
        );
    }
  }

  static PaymentType getByNameOrIndex(dynamic name) {
    final i = int.tryParse(name.toString());
    if (i != null) {
      return PaymentType.values[i];
    }
    switch (name.toString().toLowerCase()) {
      case 'zain_cash':
        return PaymentType.zainCash;
      case 'qi_card':
        return PaymentType.qiCard;
      default:
        return PaymentType.zainCash;
    }
  }
}

enum InsurancePolicyStatus {
  paymentPending,
  paid,
  missingInfo,
  resubmitted,
  draftPreparation,
  draft,
  approved,
  rejected,
  active,
  expired,
  cancelled,
  resubscriptionPaymentPending,
  ;

  bool get canRenew => this == .expired || this == .active;

  bool get canCancel => this == .cancelled || this == .paymentPending;

  String get name {
    switch (this) {
      case InsurancePolicyStatus.paymentPending:
        return S().paymentPending;
      case InsurancePolicyStatus.paid:
        return S().paid;
      case InsurancePolicyStatus.missingInfo:
        return S().missingInfo;
      case InsurancePolicyStatus.resubmitted:
        return S().resubmitted;
      case InsurancePolicyStatus.draftPreparation:
        return S().draftPreparation;
      case InsurancePolicyStatus.draft:
        return S().draft;
      case InsurancePolicyStatus.approved:
        return S().approved;
      case InsurancePolicyStatus.rejected:
        return S().rejected;
      case InsurancePolicyStatus.active:
        return S().active;
      case InsurancePolicyStatus.expired:
        return S().expired;
      case InsurancePolicyStatus.cancelled:
        return S().cancelled;
      case InsurancePolicyStatus.resubscriptionPaymentPending:
        return S().resubscriptionPaymentPending;
    }
  }

  String get nameApi {
    switch (this) {
      case InsurancePolicyStatus.paymentPending:
        return 'payment_pending';
      case InsurancePolicyStatus.paid:
        return 'paid';
      case InsurancePolicyStatus.missingInfo:
        return 'missing_info';
      case InsurancePolicyStatus.resubmitted:
        return 'resubmitted';
      case InsurancePolicyStatus.draftPreparation:
        return 'draft_preparation';
      case InsurancePolicyStatus.draft:
        return 'draft';
      case InsurancePolicyStatus.approved:
        return 'approved';
      case InsurancePolicyStatus.rejected:
        return 'rejected';
      case InsurancePolicyStatus.active:
        return 'active';
      case InsurancePolicyStatus.expired:
        return 'expired';
      case InsurancePolicyStatus.cancelled:
        return 'cancelled';
      case InsurancePolicyStatus.resubscriptionPaymentPending:
        return 'resubscription_payment_pending';
    }
  }

  Color get color {
    switch (this) {
      case InsurancePolicyStatus.paymentPending:
      case InsurancePolicyStatus.resubscriptionPaymentPending:
        return Colors.orange;
      case InsurancePolicyStatus.paid:
      case InsurancePolicyStatus.approved:
      case InsurancePolicyStatus.active:
        return AppColorManager.greenPrice;
      case InsurancePolicyStatus.missingInfo:
      case InsurancePolicyStatus.rejected:
      case InsurancePolicyStatus.expired:
        return AppColorManager.red;
      case InsurancePolicyStatus.resubmitted:
        return AppColorManager.blue;
      case InsurancePolicyStatus.draftPreparation:
      case InsurancePolicyStatus.draft:
      case InsurancePolicyStatus.cancelled:
        return AppColorManager.grey;
    }
  }

  Widget get statusWidget {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      alignment: Alignment.center,
      child: DrawableText(text: name, color: color, size: 14.sp),
    );
  }

  static InsurancePolicyStatus getByNameOrIndex(dynamic name) {
    if (name == null) return InsurancePolicyStatus.paymentPending;
    final i = int.tryParse(name.toString());
    if (i != null) {
      return InsurancePolicyStatus.values[i];
    }
    switch (name.toString().toLowerCase()) {
      case 'payment_pending':
        return InsurancePolicyStatus.paymentPending;
      case 'paid':
        return InsurancePolicyStatus.paid;
      case 'missing_info':
        return InsurancePolicyStatus.missingInfo;
      case 'resubmitted':
        return InsurancePolicyStatus.resubmitted;
      case 'draft_preparation':
        return InsurancePolicyStatus.draftPreparation;
      case 'draft':
        return InsurancePolicyStatus.draft;
      case 'approved':
        return InsurancePolicyStatus.approved;
      case 'rejected':
        return InsurancePolicyStatus.rejected;
      case 'active':
        return InsurancePolicyStatus.active;
      case 'expired':
        return InsurancePolicyStatus.expired;
      case 'cancelled':
        return InsurancePolicyStatus.cancelled;
      case 'resubscription_payment_pending':
        return InsurancePolicyStatus.resubscriptionPaymentPending;
      default:
        return InsurancePolicyStatus.paymentPending;
    }
  }
}

enum TransferOwnershipStatus {
  pending, // color : gray | icon :
  underReview, // color: orange | icon :
  accepted, // color: green | icon :
  rejected, // color: red | icon :
  ;

  String get name {
    switch (this) {
      case TransferOwnershipStatus.pending:
        return S().pending;
      case TransferOwnershipStatus.underReview:
        return S().underReview;
      case TransferOwnershipStatus.accepted:
        return S().accepted;
      case TransferOwnershipStatus.rejected:
        return S().rejected;
    }
  }

  String get description {
    final s = S();
    switch (this) {
      case TransferOwnershipStatus.pending:
      case TransferOwnershipStatus.underReview:
        return s.transferOwnershipPendingDesc;
      case TransferOwnershipStatus.accepted:
        return s.transferOwnershipAcceptedDesc;
      case TransferOwnershipStatus.rejected:
        return s.transferOwnershipRejectedDesc;
    }
  }

  String get nameApi {
    switch (this) {
      case TransferOwnershipStatus.pending:
        return 'pending';
      case TransferOwnershipStatus.underReview:
        return 'under_review';
      case TransferOwnershipStatus.accepted:
        return 'accepted';
      case TransferOwnershipStatus.rejected:
        return 'rejected';
    }
  }

  Color get color {
    switch (this) {
      case TransferOwnershipStatus.pending:
        return AppColorManager.grey;
      case TransferOwnershipStatus.underReview:
        return Colors.orange;
      case TransferOwnershipStatus.accepted:
        return AppColorManager.greenPrice;
      case TransferOwnershipStatus.rejected:
        return AppColorManager.red;
    }
  }

  IconData? get icon {
    switch (this) {
      case TransferOwnershipStatus.pending:
        return Icons.timer_outlined;
      case TransferOwnershipStatus.underReview:
        return Icons.hourglass_empty_rounded;
      case TransferOwnershipStatus.accepted:
        return Icons.check_circle_outline;
      case TransferOwnershipStatus.rejected:
        return Icons.cancel_outlined;
    }
  }

  static TransferOwnershipStatus getByNameOrIndex(dynamic name) {
    if (name == null) return TransferOwnershipStatus.pending;
    final i = int.tryParse(name.toString());
    if (i != null) {
      return TransferOwnershipStatus.values[i];
    }
    switch (name.toString().toLowerCase()) {
      case 'pending':
        return TransferOwnershipStatus.pending;
      case 'under_review':
        return TransferOwnershipStatus.underReview;
      case 'accepted':
        return TransferOwnershipStatus.accepted;
      case 'rejected':
        return TransferOwnershipStatus.rejected;
      default:
        return TransferOwnershipStatus.pending;
    }
  }
}

enum AccidentStatus {
  pending, // قيد الانتظار
  acceptedByOperationStaff, // تم القبول من قبل موظف العمليات
  rejectedByOperationStaff, // تم الرفض من قبل موظف العمليات
  acceptedBySurveyorStaff, // تم القبول من قبل موظف الكشف
  rejectedBySurveyorStaff, // تم الرفض من قبل موظف الكشف
  paid, // تم الدفع
  fixed, // تم الإصلاح
  ;

  String get name {
    switch (this) {
      case AccidentStatus.pending:
        return S().pending;
      case AccidentStatus.rejectedBySurveyorStaff:
      case AccidentStatus.rejectedByOperationStaff:
        return S().rejected;
      case AccidentStatus.acceptedByOperationStaff:
      case AccidentStatus.acceptedBySurveyorStaff:
        return S().acceptedBySurveyorStaff;
      case AccidentStatus.paid:
        return S().paid;
      case AccidentStatus.fixed:
        return S().fixed;
    }
  }

  String get nameApi {
    switch (this) {
      case AccidentStatus.pending:
        return 'pending';
      case AccidentStatus.acceptedByOperationStaff:
        return 'accepted_by_operation_staff';
      case AccidentStatus.rejectedByOperationStaff:
        return 'rejected_by_operation_staff';
      case AccidentStatus.acceptedBySurveyorStaff:
        return 'accepted_by_surveyor_staff';
      case AccidentStatus.rejectedBySurveyorStaff:
        return 'rejected_by_surveyor_staff';
      case AccidentStatus.paid:
        return 'paid';
      case AccidentStatus.fixed:
        return 'fixed';
    }
  }

  Color get color {
    switch (this) {
      case AccidentStatus.pending:
        return AppColorManager.grey;
      case AccidentStatus.acceptedByOperationStaff:
      case AccidentStatus.acceptedBySurveyorStaff:
        return AppColorManager.greenPrice;
      case AccidentStatus.rejectedByOperationStaff:
      case AccidentStatus.rejectedBySurveyorStaff:
        return AppColorManager.red;
      case AccidentStatus.paid:
        return Colors.blueAccent;
      case AccidentStatus.fixed:
        return Colors.green;
    }
  }

  dynamic get icon {
    switch (this) {
      case AccidentStatus.pending:
        return Assets.icons.waiting.path;
      case AccidentStatus.acceptedByOperationStaff:
      case AccidentStatus.acceptedBySurveyorStaff:
        return Assets.icons.damageInspection.path;
      case AccidentStatus.fixed:
        return Assets.icons.accepted.path;
      case AccidentStatus.rejectedByOperationStaff:
      case AccidentStatus.rejectedBySurveyorStaff:
        return Assets.icons.reject.path;
      case AccidentStatus.paid:
        return Icons.paid_outlined;
    }
  }

  static AccidentStatus getByNameOrIndex(dynamic name) {
    if (name == null) return AccidentStatus.pending;
    final i = int.tryParse(name.toString());
    if (i != null) {
      return AccidentStatus.values[i];
    }
    switch (name.toString().toLowerCase()) {
      case 'pending':
        return AccidentStatus.pending;
      case 'accepted_by_operation_staff':
        return AccidentStatus.acceptedByOperationStaff;
      case 'rejected_by_operation_staff':
        return AccidentStatus.rejectedByOperationStaff;
      case 'accepted_by_surveyor_staff':
        return AccidentStatus.acceptedBySurveyorStaff;
      case 'rejected_by_surveyor_staff':
        return AccidentStatus.rejectedBySurveyorStaff;
      case 'paid':
        return AccidentStatus.paid;
      case 'fixed':
        return AccidentStatus.fixed;
      default:
        return AccidentStatus.pending;
    }
  }

  String description(HasClaimRequest item) {
    var type  = item.compensationType;
    var value  = item.compensationValue.formatPrice;
    final s = S();
    switch (this) {
      case AccidentStatus.pending:
        return s.accidentPendingDesc;
      case AccidentStatus.rejectedBySurveyorStaff:
      case AccidentStatus.rejectedByOperationStaff:
        return S().theAccidentRequestWasRejected;
      case AccidentStatus.acceptedByOperationStaff:
      case AccidentStatus.acceptedBySurveyorStaff:
        return S().damageInspection;
      case AccidentStatus.paid:
      case AccidentStatus.fixed:
        var desc = s.accidentAcceptedSurveyorDesc;
        if (type == .maintenance) {
          desc += '/n ${item.maintenanceLocation}';
        } else if (type == .financial) {
          desc += s.compensationValuePrefix(num.tryParse(value)?.formatPrice ?? '$value');
        }

        return desc;
    }
  }
}

enum CompensationType {
  maintenance,
  financial,
  ;

  String get name {
    switch (this) {
      case CompensationType.maintenance:
        return S().maintenance;
      case CompensationType.financial:
        return S().financial;
    }
  }

  String get nameApi {
    switch (this) {
      case CompensationType.maintenance:
        return 'maintenance';
      case CompensationType.financial:
        return 'financial';
    }
  }

  IconData get icon {
    switch (this) {
      case CompensationType.maintenance:
        return Icons.payments_outlined;
      case CompensationType.financial:
        return Icons.build_circle_outlined;
    }
  }

  static CompensationType getByNameOrIndex(dynamic name) {
    if (name == null) return CompensationType.financial;
    final i = int.tryParse(name.toString());
    if (i != null) {
      return CompensationType.values[i];
    }
    switch (name.toString().toLowerCase()) {
      case 'maintenance':
        return CompensationType.maintenance;
      case 'financial':
        return CompensationType.financial;
      default:
        return CompensationType.financial;
    }
  }
}

//
//
//
//
//
//
//
enum ResourceType {
  pdf,
  docx,
  html,
  txt,
  mp4,
  jpeg,
  pptx,
  xlsx,
  h5p,
  ;

  dynamic get icon {
    switch (this) {
      case .pdf:
        return Icons.picture_as_pdf;

      case .docx:
        return Icons.description;

      case .html:
        return Icons.code;

      case .txt:
        return Icons.notes;

      case .mp4:
        return Icons.play_circle_fill;

      case .jpeg:
        return Icons.image;

      case .pptx:
        return Icons.slideshow;

      case .xlsx:
      case .h5p:
        return Icons.table_chart;
    }
  }

  static ResourceType getByNameOrIndex(dynamic name) {
    final index = int.tryParse(name.toString());

    if (index != null) {
      return .values[index];
    }

    switch (name.toLowerCase()) {
      case 'pdf':
        return .pdf;
      case 'docx':
        return .docx;
      case 'html':
        return .html;
      case 'txt':
        return .txt;
      case 'mp4':
        return .mp4;
      case 'jpeg':
      case 'png':
      case 'jpg':
      case 'webp':
        return .jpeg;
      case 'pptx':
        return .pptx;
      case 'xlsx':
        return .xlsx;
    }
    return .txt;
  }
}
