Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDC8ECAAD8
	for <linux-unionfs@archiver.kernel.org>; Thu, 22 Sep 2022 04:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiIVEQh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 22 Sep 2022 00:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiIVEQb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Sep 2022 00:16:31 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCAE2A221C
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Sep 2022 21:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663820189; x=1695356189;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vJJlFT3eXTgXPy9S2aXe03ywfNp1GiqtpKfKEpw/C3g=;
  b=me10BvkzvGPQPKpkAv6VOLJt9WsWWmvardyhACHV2KZzoxfesqsNY/Hc
   pQS7E6GXnnQkqW9vIlXCUHBIApdtpqTPsAxBIutnUtq0WqsEJaynOxTc0
   T3VzrpT/0Fu6kwS12CcJxaMUOevpzsi6mxE7o8QU2J1AFsiFErFXvNc+5
   Dilod7kOpYHxFRrpHKiMfnKzyB/4zwZGQShhN3dXnxrQpFyzYLcjVGghU
   46Kk2HY841vYT5P5xYX488lzUoXBLhS9m2QXPtGlIbfUFvBSjA/+cZUYI
   7o7B+xTOS28PfUUaIIzixxPhLlVRXQPw2Sv6HN4Jl8hbB66/ys9G6550v
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="301037572"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="301037572"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 21:16:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="708720506"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Sep 2022 21:16:26 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 21:16:26 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 21:16:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 21 Sep 2022 21:16:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 21 Sep 2022 21:16:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odL6MsyjNh0kMC6n/hEGTNuU6oypRQCZbHenlGyv1k8h1pKRIXKMA9vvqiQJjgP+/19rL5XpmsrAzKHrDTrwL+38oW8322ZaZpXZgpLyoXER4t29GpGn8GR6bN0oN6rI3Z4B61BHwZ9XaIZ9flKcuxTXBqa0eL4lYjb04oz/prVsMKq33RMlrvJVMyPTk+n/nU1rKuYg8uZAIi8dyHnSvGAZpSNnt8kBu8U4D0zeFaHDNiwJwuV4vXPdaIhyjxS8tOI+YajT4UylHlQpi+QMpj7sgB2WneKdxFK/y2hv+S/u/a+JO3iAEJ/3S5ApiljKNzbW8U8BiGB4W+Ws04o+VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJJlFT3eXTgXPy9S2aXe03ywfNp1GiqtpKfKEpw/C3g=;
 b=TP7MtuL3F4A6ejjd4KxtK7ZUBAJU18HFzf6hlk4KOWtu4eBaSvZaV3ZHVTy3qEf+Fo7s08F3Caa/KHc3K4Su9R92PhxrUn3H2zr5L/uK49WjR7lrzapfUCl1XU0nPM3hetE3q+Q99I5CmJHEwFwfo9++UnzCBSjpJgVw/wnT2nvw3N9ylCrD89/avyYwtWxrL2viVzYhOoutNWqDlhXemG9aprwFUCGovwsE2N/fJTO3a2/O0b0hLSTGq6rptsMxHJiKNQDu7oJ6OgW02uqFfobj/HMZaiAt/T7FwnV7BYBcgCZTLeB2qCta4YJbQuzLt3L78j80Th0EeUVzRcmjgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM5PR11MB1913.namprd11.prod.outlook.com (2603:10b6:3:10b::20)
 by DS7PR11MB6063.namprd11.prod.outlook.com (2603:10b6:8:76::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Thu, 22 Sep
 2022 04:16:23 +0000
Received: from DM5PR11MB1913.namprd11.prod.outlook.com
 ([fe80::78c7:fdce:2113:2073]) by DM5PR11MB1913.namprd11.prod.outlook.com
 ([fe80::78c7:fdce:2113:2073%7]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 04:16:23 +0000
From:   "Jie, Keyon" <keyon.jie@intel.com>
To:     Amir Goldstein <amir73il@gmail.com>
CC:     Keyon Jie <yang.jie@linux.intel.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Subject: RE: Does overlay driver work if built in to the kernel?
Thread-Topic: Does overlay driver work if built in to the kernel?
Thread-Index: AQHYzVFnvkOSexv080mvcPyfGOaDUK3pciuAgACDTRCAADLJgIAAsMaw
Date:   Thu, 22 Sep 2022 04:16:22 +0000
Message-ID: <DM5PR11MB1913B748BB8E59BEF575529FF14E9@DM5PR11MB1913.namprd11.prod.outlook.com>
References: <6810f0fa-ded3-420d-6978-0faf9667d307@linux.intel.com>
 <CAOQ4uxj1V8EvJuEthaiZK102P8PX4idFmC0BSTuhabPQo6kD0g@mail.gmail.com>
 <MWHPR11MB191913944274BE566826A4BEF14F9@MWHPR11MB1919.namprd11.prod.outlook.com>
 <CAOQ4uxjFeV9CP7xLrCsWNMbZ3F1CKcea-Tr7Wnx95YLpkvUkzw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjFeV9CP7xLrCsWNMbZ3F1CKcea-Tr7Wnx95YLpkvUkzw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB1913:EE_|DS7PR11MB6063:EE_
x-ms-office365-filtering-correlation-id: e4a7c55d-8839-4c18-291a-08da9c51358b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wKJwlF8M3dtysLoHDmfMiKSVgbJEMkCC1Lbncwr1WSJf2t+ohvmWs/28A+EWRez8F99gvYLSYV9+zJMMmqlO/5hs/IyK9fr2EF7sp5owiZ1aQAqMFPTUI1B7Roc6Q0ogRGRwNXveDCVQbdTdnYmckGjzvDer+xvFyNIKwb2We3QaKyY7sp95RIuK38Aeccmbs1Tzse0yqM8/pY/niuXlcwiUT1VmVm8xRXxrEYXYaOWgSK0fU3fNBD8Gpug65M5Wxq0KLHBLk0m9t19Xkd88VA7fymUhhZS/aYvIcaKmcuGkssOGJDZITOr3zZ5em0zIuAMnwAcqjkQkx1zqvHmZOVq3MSw5brN53KSI4xswjSbeo6Rj7VYH05w1hOtBKU/ftbx09JYTz7GI/8Uo/XqdnSwgdmJpNBh+QTNEHh1ncETnoYKx/hRC/z5KwH2lgGsmmpBlnyksYzkSI3iTJP3OEel0l8FknDJFDcUcMhR8PRrSWKBDj0Fk07TmXjuGWyMl1rhzWD1fmVejHLC4Z/tYkluAMbHzxgByeTQyquV8L/+XXPSVp3gJ33sghoYwcMdkxvIBQelrUOd2pu8zna8EGSDUJn7UuTVzC8EwlRESyJ1SKfizU0MpY4ZQCdJjMAtyYDm1VJVy0/RMXksKBR7x/ySQuS5YFcqiFXzhrr8JL+PcCuVtZ+Z9qmDJJ7seqO0FTgpskSd0T9ZZ0AISpvq5I0WBVFY4/20qLd9hpaMxoqi7iXB6NX4ntuISTa9K3Hs4zY9ejrZmwRzsotHP7LsQu/JIw/KkmYWXSmgA/5FOmtCSlyzzO1rMHasQzm9i8jI6cOTQ5Vj1TkTAS/ttNxqvNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1913.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199015)(186003)(6506007)(83380400001)(53546011)(7696005)(9686003)(26005)(122000001)(64756008)(52536014)(66946007)(66446008)(55016003)(5660300002)(4326008)(76116006)(8676002)(66476007)(478600001)(966005)(41300700001)(71200400001)(86362001)(66556008)(316002)(8936002)(54906003)(38070700005)(6916009)(82960400001)(33656002)(2906002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXVkb21FTXorMU9YTzBLR001T2ZwZldqOVoyYWdoVGVibFdkdFJPWlA3eDVm?=
 =?utf-8?B?NzhDY2cxb3pzWDlyaWRsMzcwNXdITlRaK0hOM1c2SmEzcEZ1NFNrQ2lXNnZM?=
 =?utf-8?B?NlVleWVDWmtFN0liUXNxR2dHTnE2dGtrWTJkWFN3V0laRThhVm1OWWV2akxn?=
 =?utf-8?B?a0N1d2ZFZldUWW01YmIxZU8vUHRTTjFLUmYxQlpHL0JYVzAxc1ZhMmh3NFBQ?=
 =?utf-8?B?SnBqcGxFSmduamU1blZZZFU5dXplZVNXZEpLY2JORk1Pd0J2RjZwMjFKWVpP?=
 =?utf-8?B?NVZIRVFuWSs2YXV6VlprVmRMbDdaSmhBQjlxZTd6KytrZkJVMWIxc0JWMjZs?=
 =?utf-8?B?ejdMQkFVVnVyNThEVnd3d3h3dnFtck5YS0d1UllnTk1XRzNzWW1ka2huMUVJ?=
 =?utf-8?B?TUlaRmFmUzY5cnUxSDZETkhybVpxODYvSTVGcHFyOGhMRmxFRG1QNS9zRU9J?=
 =?utf-8?B?eHpqUm9iVXE1ZjhuZzhXNVU3aVluVnNxL3Q3S2FRVlMycTBZdUMxWTg3UEMr?=
 =?utf-8?B?enFnM0h1OGNMeHY3VG9BcEtTbTNxNkZxQ3Q0VkJXT0FSZDFsajFieVlKaC9N?=
 =?utf-8?B?bGFWWTZGMDVSeExmeUVid1FXT1NiT000RVZPbjZnaE50RnVmNVVaeGRQc0w5?=
 =?utf-8?B?NXk0Q1hpZTEwNlpDczRvTDBvVSt6TDI2Y05uMm1MMGZhQTBTUk5GT3BReno1?=
 =?utf-8?B?MXFLbFJFZEJSNjBKZkdJcEd5V0Q5ck1oUXVwbXpkdHRleFlZQnhvM2VLSnVh?=
 =?utf-8?B?eUxjOWVmb0xBRTZoOC81REFWU08yRktGZXExL2FGUmJrazRSbWlieHRxZko4?=
 =?utf-8?B?cFE5Slp2TjlJUjRzT1BJd3RMb1d6NXFsQTJaRmoxOUxwRlUreW81clM3bUJ2?=
 =?utf-8?B?NG5XeGpXOTBCbnc2cmUwdnRvRG5qOGowTmxxOXZVWndla2t1OEFIS1laOGIx?=
 =?utf-8?B?c2w2aGY3STBMWWh6dFJvendmdVNUS0JBRHUwUHp6bWRnbTc1UGlaeXlOdU9U?=
 =?utf-8?B?TXNLSUo0NkE0aVpDQWc3YWtYZW4xOHB4QUdGa3Ird3ZkTG1FNXJQMStOeTJD?=
 =?utf-8?B?QjRTVldURzNEaU52TUlqMEtDYklTbDBZeTVsWmRhMUU1dU9PcEozQnNoRTVa?=
 =?utf-8?B?a090a2FLQXF3cG92REowVUcramZtWGdxMGc1VmtvcTE5TWRWZm1uOTVOYmhM?=
 =?utf-8?B?dEFlbzRENjZrMmx3TEVPVWwxcjBFM2FZN3Y4OXp3NDZiTDdXdnI1RGRWQ1Zr?=
 =?utf-8?B?T2xSWlZKNm9qTC9WWnp4VExzNk9aYlF0NUhQMEVBVFZhd0lhUDV2OFdZVkFB?=
 =?utf-8?B?TGtXQ3RoYzB0UjZMMkk0dEdCd2lvaWIyV1NhTUlLcm5PdkRxSWFGTUFqRjB3?=
 =?utf-8?B?dW5obW5FcW42WUhtbG1kd0FOQXVuWGVQRGJmbzFGZ0pIYmhUOW1KMXdDbTA3?=
 =?utf-8?B?b25ERklQc1Naa3dKbUxGb0dBQThsamh0M2l6M0hkSDd5WWd4YUtoeHJXSENR?=
 =?utf-8?B?UElicDF6YWJxTmNQV1l1aHpJNGJJWDlnTTAyTFpLQ1Q4dVdPOGlnby9NZjFQ?=
 =?utf-8?B?R0VGRkIwaXRqMytyYUk3TnBya0FEc1JYQjc1ZGFUeVZRcVhoSFcweW52a3po?=
 =?utf-8?B?eUZHR01FRXlGTmF0RStCMzgwbEwrdE16ME9BREhjT2I2SnN5TGMxY0dzOGRx?=
 =?utf-8?B?TUlNUUpYbUVnb2F6Mng0YU1QSWtjTitaUmptREI2UC9pR0szQjJ0aVNQTUl5?=
 =?utf-8?B?NEV0Yk1SUXQxdmZYbEpkblBDbGJ1MmhVZXprUFdFMHUzdmFaaExNYy9rSGNY?=
 =?utf-8?B?ZmIvMjZySjg2dHhXOVBjOUgydGNJN0U0QzMrWFl3YlliSTRVUmJJYk1RMHdh?=
 =?utf-8?B?dmV5RkRnWW5YL0J1Snk0YkRDVTRWUmEyaGt5WTllQUtRR0t4ckNna21sdXk5?=
 =?utf-8?B?SWtITVNxeklpSlJYd2hWWkliVzcycHZvSzFUdlhwKytmSm14TWxQaDkzRmdF?=
 =?utf-8?B?RmpLUTFFVjIycXcyQTV0UWp3NFhzUGJnazlkaHl4dFVubTdCZ3RucXBHWkRm?=
 =?utf-8?B?RHlZM3BGY1hKOWhTUnBnNmJGY2lPZGNQSmlXeUZKeUtxcVNOaVNxQmhVZzNW?=
 =?utf-8?Q?H+hgbrLxO8rx6IuoeSEKG49Qc?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1913.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4a7c55d-8839-4c18-291a-08da9c51358b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 04:16:23.0318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FQqv7KPW78XavZ3rahl6LdfijoIwyJuws+VSazvZTASDx3Vt3YmCVBCksNirS/oXvuU/rUMMbkpFR5weCB2Ckg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6063
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbWlyIEdvbGRzdGVpbiA8YW1p
cjczaWxAZ21haWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIFNlcHRlbWJlciAyMSwgMjAyMiAx
MDo0MiBBTQ0KPiBUbzogSmllLCBLZXlvbiA8a2V5b24uamllQGludGVsLmNvbT4NCj4gQ2M6IEtl
eW9uIEppZSA8eWFuZy5qaWVAbGludXguaW50ZWwuY29tPjsgTWlrbG9zIFN6ZXJlZGkNCj4gPG1p
a2xvc0BzemVyZWRpLmh1Pjsgb3ZlcmxheWZzIDxsaW51eC11bmlvbmZzQHZnZXIua2VybmVsLm9y
Zz4NCj4gU3ViamVjdDogUmU6IERvZXMgb3ZlcmxheSBkcml2ZXIgd29yayBpZiBidWlsdCBpbiB0
byB0aGUga2VybmVsPw0KPiANCj4gT24gV2VkLCBTZXAgMjEsIDIwMjIgYXQgNTo0OCBQTSBKaWUs
IEtleW9uIDxrZXlvbi5qaWVAaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+DQo+ID4gPiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogQW1pciBHb2xkc3RlaW4gPGFtaXI3
M2lsQGdtYWlsLmNvbT4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIFNlcHRlbWJlciAyMCwgMjAyMiAx
MTo1MCBQTQ0KPiA+ID4gVG86IEtleW9uIEppZSA8eWFuZy5qaWVAbGludXguaW50ZWwuY29tPg0K
PiA+ID4gQ2M6IE1pa2xvcyBTemVyZWRpIDxtaWtsb3NAc3plcmVkaS5odT47IG92ZXJsYXlmcyA8
bGludXgtDQo+ID4gPiB1bmlvbmZzQHZnZXIua2VybmVsLm9yZz47IEppZSwgS2V5b24gPGtleW9u
LmppZUBpbnRlbC5jb20+DQo+ID4gPiBTdWJqZWN0OiBSZTogRG9lcyBvdmVybGF5IGRyaXZlciB3
b3JrIGlmIGJ1aWx0IGluIHRvIHRoZSBrZXJuZWw/DQo+ID4gPg0KPiA+ID4gT24gV2VkLCBTZXAg
MjEsIDIwMjIgYXQgMzozMiBBTSBLZXlvbiBKaWUgPHlhbmcuamllQGxpbnV4LmludGVsLmNvbT4N
Cj4gPiA+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBIaSBhbGwsDQo+ID4gPiA+DQo+ID4gPiA+
IEkgYW0gbmV3IHRvIHRoZSBvdmVybGF5ZnMsIEkgYW0gaGl0dGluZyBpc3N1ZXMgdG8gbWFrZSBr
ZXJuZWwgbW9kdWxlcw0KPiA+ID4gPiB3b3JrIGluIGEgY29udGFpbmVyIGVudmlyb25tZW50IHdo
ZXJlIHRoZSBLdWJlcm5ldGVzIGZlYXR1cmUgcmVhbGx5DQo+ID4gPiBuZWVkDQo+ID4gPiA+IHRo
ZSBvdmVybGF5ZnMgc3VwcG9ydC4NCj4gPiA+ID4NCj4gPiA+ID4gSSBmaWd1cmVkIG91dCB0byBt
YWtlIG92ZXJsYXkgZHJpdmVyIGJ1aWx0LWluIHRvIHRoZSBWTSBrZXJuZWwgKGFuZA0KPiB0aGVu
DQo+ID4gPiA+IHNoYXJlZCB0byB0aGUgY29udGFpbmVyKSwgYnV0IGxvb2tzIGxpa2UgdGhlIEt1
YmVybmV0ZXMgYWx3YXlzIGZhaWwNCj4gd2hlbg0KPiA+ID4gPiB0cnlpbmcgdG8gY3JlYXRlIG92
ZXJsYXlmcyBtb3VudHMsIHdpdGggZXJyb3JzIGxpa2UgJ3Blcm1pc3Npb24gZGVuaWVkJy4NCj4g
PiA+ID4NCj4gPiA+DQo+ID4gPiBVc3VhbGx5LCB5b3Ugd2FudCB0byBsb29rIGF0IHRoZSBrZXJu
ZWwgbG9nIHRvIHNlZSB0aGUgcmVhc29uIGZvciBmYWlsdXJlLg0KPiA+ID4gVGhhdCBpcyBsaWtl
bHkgYmVjYXVzZSB0aGUgY29udGFpbmVyIGlzICJ1bnByaXZpbGVnZWQiDQo+ID4gPiBtZWFuaW5n
IG5vdCB1c2luZyB0aGUgc2FtZSB1aWQgMCBhcyB0aGUgaG9zdC4NCj4gPiA+DQo+ID4gPiBEb24n
dCBrbm93IHdoaWNoIGtlcm5lbCB5b3UgYXJlIHJ1bm5pbmcsIGJ1dCBvdmVybGF5ZnMgY2FuIGJl
IG1vdW50ZWQNCj4gPiA+IGluc2lkZSB1bnByaXZpbGVnZWQgY29udGFpbmVyIHNpbmNlIGtlcm5l
bCB2NS4xMToNCj4gPiA+DQo+ID4gPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC0NCj4g
PiA+IGZzZGV2ZWwvMjAyMDEyMTcxNDIwMjUuR0IxMjM2NDEyQG1pdS5waWxpc2NzYWJhLnJlZGhh
dC5jb20vDQo+ID4NCj4gPiBUaGFuayB5b3UgQW1pci4NCj4gPiBJIGFtIHVzaW5nIHY1LjEwIGtl
cm5lbCwgc28gbG9va3MgSSBjYW4gdHJ5IHRvIGJhY2twb3J0IHNvbWUgb2YgdGhlIHBhdGNoZXMN
Cj4gYW5kIHRyeSBpdCBhZ2Fpbi4NCj4gPiBJIGFzc3VtZSB0YWtlIHRoZSAxMC1jb21taXRzIHNl
cmllcyBmcm9tIE1pa2xvcyBzaG91bGQgYmUgZW5vdWdoPw0KPiA+ICAgICAgIHZmczogbW92ZSBj
YXBfY29udmVydF9uc2NhcCgpIGNhbGwgaW50byB2ZnNfc2V0eGF0dHIoKQ0KPiA+ICAgICAgIHZm
czogdmVyaWZ5IHNvdXJjZSBhcmVhIGluIHZmc19kZWR1cGVfZmlsZV9yYW5nZV9vbmUoKQ0KPiA+
ICAgICAgIG92bDogY2hlY2sgcHJpdnMgYmVmb3JlIGRlY29kaW5nIGZpbGUgaGFuZGxlDQo+ID4g
ICAgICAgb3ZsOiBtYWtlIGlvY3RsKCkgc2FmZQ0KPiA+ICAgICAgIG92bDogc2ltcGxpZnkgZmls
ZSBzcGxpY2UNCj4gPiAgICAgICBvdmw6IHVzZXIgeGF0dHINCj4gPiAgICAgICBvdmw6IGRvIG5v
dCBmYWlsIHdoZW4gc2V0dGluZyBvcmlnaW4geGF0dHINCj4gPiAgICAgICBvdmw6IGRvIG5vdCBm
YWlsIGJlY2F1c2Ugb2YgT19OT0FUSU1FDQo+ID4gICAgICAgb3ZsOiBkbyBub3QgZ2V0IG1ldGFj
b3B5IGZvciB1c2VyeGF0dHINCj4gPiAgICAgICBvdmw6IHVucHJpdmllZ2VkIG1vdW50cw0KPiA+
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWZzZGV2ZWwvMTcyNWUwMWEtNGQ0ZC1hZWNi
LWJhZDYtDQo+IDU0YWEyMjBiNGNkMkBpLWxvdmUuc2FrdXJhLm5lLmpwL1QvDQo+ID4NCj4gDQo+
IE5vdCBzdXJlIHlvdSBjYW4gdHJ5Lg0KPiBUaGVyZSBtYXkgYmUgb3RoZXIgYnVnIGZpeGVzIHRo
YXQgbmVlZCBiYWNrcG9ydGluZy4NCj4gSXQgaXMgbm90IHJlY29tbWVuZGVkIHRvIGJhY2twb3J0
IHN1Y2ggYSBmZWF0dXJlIGJ5IHlvdXJzZWxmLg0KPiBZb3Ugd291bGQgYmUgbXVjaCBiZXR0ZXIg
b2ZmIHRha2luZyBvciBidWlsZCBhIG5ld2VyIExUUyBrZXJuZWwgKGUuZy4gNS4xNS55KQ0KDQpU
aGFuayB5b3Ugc28gbXVjaCBBbWlyLiBKdXN0IHRyaWVkIGFuZCA1LjE1IHdvcmtzIHdlbGwgZm9y
IG1lIQ0KDQpUaGFua3MsDQp+S2V5b24NCj4gDQo+IFRoYW5rcywNCj4gQW1pci4NCg==
