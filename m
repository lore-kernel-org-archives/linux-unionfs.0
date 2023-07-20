Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1897CEB64DC
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Jul 2023 16:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjGTQd2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 12:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjGTQd0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Jul 2023 12:33:26 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2133.outbound.protection.outlook.com [40.107.92.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC1A1989
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Jul 2023 09:33:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9/HsCuVtP3tO9iY9m/YCJ2BvpPCECXTCg5jNhlnWIRwnhIHwhVesNHRo3f4c3Y8B9DIAxkWV9V2OLjbQHytWyJpJJ/YukVozuvO+JvB4VqBjsrVX+Soi9tbL9I7FZmqdPZHLwc9iDd9Fp1WuyCOFQnzGaABeJivbI0e9lOHFr3dPP/H6z88vtuJNXLQZpYr/7MaJ7UUql8P1KdWcKtVhTl12h0tDeXPIaInpeu7B+rKroD+cDrhLuZJTVrd7qJUAgTNix7Q8+7LX2PTRDoobKRjq4YfJM7+skvW5QqHjjSE1+kFDTZs1ektLkiLr7R9mgqjAOnHmVgqjy+qL2ARQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRkgF6eLvETj2I735ravWRaPC4Xlg8RJRX8ch973QmI=;
 b=Ab6nUqpProrrdA8IWB07E4B78RjHpZs1r2G4cKCuDc19xvt4+awjY/Za8FRKbf/pqTnuPIdaguPAEeBLxN1yP7ZI8YfJzrjaw/ESPmgh57fy3YMgtbrEqYaVgxbQsVWAdsfSLSrlQlnjouQ+lZoxbBaezfBNY/WYcBBo20pyH+lAvw1tEjlvPc1AThy1F71DR1t/MD10j083hgkzt6eYQFkDVF86/FvnJ8ILrOAdmVNlz3FCp6qSWa4NKwBYvpWTGq61JRzdYWA8+iJdU1014vod48YdcXJCval1GmS8DrUYbty1R1iQpHXkrN1wSDX6zMt80ImaLi9gQ8F6GL90Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=obsidian.systems; dmarc=pass action=none
 header.from=obsidian.systems; dkim=pass header.d=obsidian.systems; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=obsidiansystems.onmicrosoft.com;
 s=selector1-obsidiansystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRkgF6eLvETj2I735ravWRaPC4Xlg8RJRX8ch973QmI=;
 b=TPswq/SFKt7QfAKBpdnCDG6KweAVzGi+lPh3f9AK5q/tV3lDjWpaiMEW27kiW3Klh2VXBQOoeD4GVzmhB5o9UPoYUdCWFzGh8jwxPg1bY3bCgydP2Ub4Q+dXj2duFxiFvsR/3H9g7JAYAP7EHJSAClu8FSXVD5YGpAGINfyij6U=
Received: from PH7PR14MB5569.namprd14.prod.outlook.com (2603:10b6:510:1fb::16)
 by PH8PR14MB7432.namprd14.prod.outlook.com (2603:10b6:510:1cf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Thu, 20 Jul
 2023 16:33:14 +0000
Received: from PH7PR14MB5569.namprd14.prod.outlook.com
 ([fe80::a501:92f0:c256:c2b1]) by PH7PR14MB5569.namprd14.prod.outlook.com
 ([fe80::a501:92f0:c256:c2b1%2]) with mapi id 15.20.6609.025; Thu, 20 Jul 2023
 16:33:13 +0000
From:   John Ericson <john.ericson@obsidian.systems>
To:     "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
CC:     Dylan Green <dylan.green@obsidian.systems>,
        Nathan Homesley <nathan.homesley@obsidian.systems>,
        Ben Radford <benjamin.radford@tweag.io>,
        Ryan Mulligan <ryan@repl.it>
Subject: "Resetting" an overlay fs entry; clearing the upper layer and
 revealing the lower layer
Thread-Topic: "Resetting" an overlay fs entry; clearing the upper layer and
 revealing the lower layer
Thread-Index: AQHZuPyPVjqAOjROjky9Pum6cGQnI6/CmjuA
Date:   Thu, 20 Jul 2023 16:33:13 +0000
Message-ID: <PH7PR14MB55698C0C851B995C9E8C649AF53EA@PH7PR14MB5569.namprd14.prod.outlook.com>
References: <PH7PR14MB55699F84995FB1FBBEA5663BF53BA@PH7PR14MB5569.namprd14.prod.outlook.com>
In-Reply-To: <PH7PR14MB55699F84995FB1FBBEA5663BF53BA@PH7PR14MB5569.namprd14.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-imapappendstamp: PH8PR14MB5900.namprd14.prod.outlook.com
 (15.20.6609.010)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=obsidian.systems;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR14MB5569:EE_|PH8PR14MB7432:EE_
x-ms-office365-filtering-correlation-id: 3a62676e-d041-418f-2ec1-08db893f0343
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bxpsr8qSl+jNa07vVn0pzUQTBVI0Ic4deMhwIfftNzqsKzQzJlJaX/SVAlZQ9XdP4BDrCxiAVCEOwjeH/QpWPeM9EPTBjjk/ER9UNOwNtF7Y8O/ise/i8a6O3lhpm722qmb/5M0sVusQlRMEAhRuXq9/09qfkUhTSRYiAYuzy26soLsCBqWXgFubYjPjtl4cCzo13hAExieeyYjDL8XE43ksbqiY2E6ulGf/ZMvW6wPhlr6UOkUOLji0TEojJd+IfZXcNrp+Y6RAOT0DSnsi47BiYJD3Ec2pAvUusjF8OOYOLQVcKfVLomjy8YnUg01T1LV/uvD6PPhdpMn+4SakITNgApfaRoLtCQvgyFzKhUi23F5aJ+6X7gQKC2H1dYijPW78AuvY8s8HyCzW31hwVdH+HrVvjgDmz6eyEXy9FvsG7pBmBXaxV3yOXbggwLk59Hte4J2jf8CbUl9coOOwq69OJkOYPZhS9T1bGwXweFu6ZanMnyyus6/Sgf37hy/hphte7tpcB9re+p+Ymt8OSfSnZoUkO/I5uE56cndJlGOvYt4/VzBuPtLV56xSpqDXyJxiTFIBLycwuibpWixRNz4D4baUzjLzALdXIlJLm6eIyLrpk63Rn6EsjRPG26r1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR14MB5569.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(39830400003)(366004)(136003)(451199021)(66946007)(66556008)(66476007)(76116006)(64756008)(66446008)(91956017)(316002)(4326008)(6916009)(38100700002)(9686003)(7696005)(122000001)(26005)(6506007)(186003)(83380400001)(71200400001)(33656002)(55016003)(38070700005)(478600001)(2906002)(86362001)(54906003)(52536014)(44832011)(41300700001)(5660300002)(8936002)(8676002)(46492021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?XFAWg+peYsOR/L+dXuehb0DcE7llKDBpy5kcq9GM9Uv68lPcsUSnmbW1KS?=
 =?iso-8859-1?Q?IU/KzbQXnCA9moGoGwuT8PSerLGKw/nISkeWtZdUEFxPkjtGDFMy4Dk312?=
 =?iso-8859-1?Q?LAEI8Up/bYWT9g0OKIKLNSYu/EGKSMVCkmb4yEIwYJy12Veibz/G+2YUws?=
 =?iso-8859-1?Q?CV6YIx3NYaTpsi1k4VBbpsZuSg7/PvQ9IwUtKtKXr6rn8EBrnIvth0dxVX?=
 =?iso-8859-1?Q?4+8tl6trUj1QoMMk8Gj5Jd2gCCiJ0GXGjv5Mlsl2GvdfBMdwKQtRloFVK+?=
 =?iso-8859-1?Q?5J9xhkOSZONOZaMBDaEGwGc9K6oFl9tdblKGeA4b/6UETktXgr9CxozI4I?=
 =?iso-8859-1?Q?h4uinR8sajjxzS5Xns+Kw1IzlGciA8weCsoS+3b80yplaiOm5yrQx40blr?=
 =?iso-8859-1?Q?nEUVBw8OTqb0WEFRyfSjt4571t+jwfWGWGDIqpHXpfmlls/bdjg8lTZRdZ?=
 =?iso-8859-1?Q?lDf3+E1Ng20SO4sPReR0BZdlWAfZvhi6GfQOs0wiE1xLgz/kCQ0+fBvv2i?=
 =?iso-8859-1?Q?DDje2VFmPvv/xftwqi4BTWF1uYOo/liHVDfEGNmTnbrFH8Q3BAdDYqVWm7?=
 =?iso-8859-1?Q?jExfXod9ij4ycXIB9tzkHnNxcqCKc1fMiTNbyR1ICTo/DXB77B4aSxLjiN?=
 =?iso-8859-1?Q?an4cqf1tVavt80M9VsgLcoJYoW7D92d5c91eN07rLQVhJZKE2Uf6fh9o4d?=
 =?iso-8859-1?Q?iJKRScHpt4aI5mShU67/BnkVBYoxAoVsM6zPvJFZTArnWO2/mwZWnhLDWm?=
 =?iso-8859-1?Q?mzMcht3XdU/58PNL65LVAaD2Kz8zaa+w4DYSiQP5+ElUFrVxpBwdQiyDXT?=
 =?iso-8859-1?Q?cuSUPCnwOtTLwFS1DMGP7Viw0oYkDMHgCcCvIa1K52nWqbY219VH9MGVvB?=
 =?iso-8859-1?Q?vKx1ycKnVKqf97aqvTBZfEUhJ23mBM3w3M30014yuuvOVpsws7f075SROY?=
 =?iso-8859-1?Q?7Vw8LW5G5gjKfYfUqICmNiVUBEEQpqHvzUV8eCUOY129Q9J6pM1QiqBdiE?=
 =?iso-8859-1?Q?uRVdqnJ5Rm1s7bArbPETY0XyhCA0eG4DzXpWGRxF3IyCnEyjaavMfAgach?=
 =?iso-8859-1?Q?UyPFi+++Rmz9Fafu/ZVUxy3GMRsU/vmx3nfxyNrSaNLKY26SzGBmYc3+Z4?=
 =?iso-8859-1?Q?C1s8NkuWG+cDdGZmLhF/1KtjPxw3QDNS7k+yVlb8KBiCHPyFDVJL0OWrXE?=
 =?iso-8859-1?Q?R6JmMm59+EC7A7U1y1wldwhB0Rss2iN/ZbWkGondB3rXfZ7lr0NqhcJ6mL?=
 =?iso-8859-1?Q?rwMmyKYZT5XxnmJkqAUeqEXx0ViuK8vYRNaRpnxTcTTgnEb2l4mwzdjSqD?=
 =?iso-8859-1?Q?U8oLFfoXVDCFEGNGIdTvldQJP8thMOwcyFhQSHWvBecJ6FtUPBeVQQZolI?=
 =?iso-8859-1?Q?LO53c180djLwQR1t3ijVz507OWcUhTdvrTcccxKga/VDVH3Y14adUpq+Pv?=
 =?iso-8859-1?Q?8xXoBlB+RTTCROI/MnChWRs2/lg7ujYK7mRDDLzRnIIUiY2kcbgQ6rgwoI?=
 =?iso-8859-1?Q?I4GSw4YmjzBimXRHwxsqKWAp/sL/Mjxs7ctaPgZ8mcxaek0okuJqXjfkgk?=
 =?iso-8859-1?Q?lNkApEzn+sk59GgQPuUkD7KxnkXlZVu/bjwPbttVpLPHWC1FczQ9eA3+h1?=
 =?iso-8859-1?Q?M1DBEN7CTTMspdLrhLWZexajBxj15SeLjrCp/rd9O/lJijhrZGTyUHTg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <79C1BC6AF79F2340B59D1908102B118F@obsidian.systems>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: obsidian.systems
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR14MB5569.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a62676e-d041-418f-2ec1-08db893f0343
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2023 16:33:13.3346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9e4fbd9c-5fe9-457b-906b-5ad50664f878
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M5BkGWyESxuUBYlvFWdukS6i2UdC6Lr4gk4XDMIEJgpF8FPWXreBGBs+KbNxmZf4rd5AmjWjghiAe7obDHLW4e8zIfqQ/WWkKQhxUYAQkqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR14MB7432
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Sorry, I missed the existence of this more specific mailing list. Below is =
=0A=
the email I previously sent to the overall list =0A=
(https://lkml.org/lkml/headers/2023/7/17/1478)=0A=
=0A=
-----=0A=
=0A=
We would like to be able to "reset" an overlay-fs directory entry, i.e. =0A=
remove whatever might exist for this entry in the upper layer and revert =
=0A=
back to whatever is in lower layer. This operation would be akin to a =0A=
regular removal, except without creating whiteouts to cover up anything =0A=
in the lower layer.=0A=
=0A=
As far as our team could discern, the kernel currently does not support =0A=
this operation. Thus, we are considering what would be necessary to =0A=
implement this ourselves. Our initial exploration led us to =0A=
`ovl_do_remove` within `fs/overlayfs/dir.c` and in particular this =0A=
conditional:=0A=
=0A=
 =A0=A0=A0 if (!lower_positive)=0A=
 =A0=A0=A0=A0=A0=A0=A0 err =3D ovl_remove_upper(dentry, is_dir, &list);=0A=
 =A0=A0=A0 else=0A=
 =A0=A0=A0=A0=A0=A0=A0 err =3D ovl_remove_and_whiteout(dentry, &list);=0A=
=0A=
That seemed like a good place to begin --- if one were to force the =0A=
first case no new whiteouts would be created, correct?=0A=
=0A=
Assuming that is indeed the right place to start, I have two follow-up =0A=
questions.=0A=
=0A=
1. Since the desired end result of the operation is strictly closer to =0A=
the lower layer, should we possibly eliminate some of the other =0A=
operations in a fresh copy of this function? For instance, might =0A=
`ovl_copy_up` be unnecessary because if the upper layer already doesn't =0A=
"contribute" to this dir entry, no action would need to be taken? =0A=
Additionally, what is the significance of `nlink`? We have not found =0A=
much documentation for it; from what we understand, it's an `xattr` used =
=0A=
so some information for the overlay-fs is persisted on disk.=0A=
=0A=
2. What is the recommended approach to expose this functionality? We =0A=
assume it would be through a new `ioctl`, but with no existing =0A=
overlay-fs-specific `ioctl` as a reference, we are unsure if that would =0A=
be the correct choice. We presume there are best practices on this =0A=
matter that we are not currently aware of.=0A=
=0A=
Our intention is to upstream this patch if we write it. It would be =0A=
therefore beneficial to discuss any objections or concerns beforehand. =0A=
For instance, one possible issue could be overlay-fs usage which =0A=
presumes that covered up lower layer data is private and inaccessible. =0A=
To make it possible to preserve that invariant, permissions for this =0A=
operation would have to be distinct from write permissions. This concern =
=0A=
can thus be addressed, but it would increase the scope of the patch.=0A=
=0A=
Thanks,=0A=
=0A=
John=0A=
