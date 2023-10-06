Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77DD6E81E1A
	for <linux-unionfs@archiver.kernel.org>; Fri,  6 Oct 2023 16:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbjJFQo1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 12:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbjJFQoX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2023 12:44:23 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F1D1BC9
        for <linux-unionfs@vger.kernel.org>; Fri,  6 Oct 2023 09:43:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQaZbvgBjZ5PwlJJ3JPG4NsSx/Hv0Xg8Ce3oZBy3w6kuA+FkKGm2ir9tg0l445lHQBmIcTWjgyI4Qz9McPTGcloNhm9/AIdXjHnUcYZYKQXx75l+/k8dFjv0G7Eh96R+zFfn1XhadB27hq/b8s5jGsrvOqp/krdU3qxD/+RBB0hytISEkIIzDvs1sqkK05spQ2ogGN50t6TQumy0aF/XaZZgjUgrqhA2GTu26MBhvnyNo165HQYZ7C654FszKP0e+U/hNjSIa85gx6eFO9elWl0ReYo5eoXMYb0tktIN57tnDj3YWK+MTKuFYFYq+6hL+qrm0Cr6TN/U0ikam0Evfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TvQhom1lK7kmCmnzrZb0tL5hjnrdJVuho/xJ5IQmVQY=;
 b=jjpcjYTfdMgAekUHVVDt2H35u9d/LCzSxC1elWPlokymlDUCabnZ3b0dtoQH8JFnAzfVysyV/M7EHz4VcNluBIsTTAbix5gFTiV2KO5RSDLvuCN8k/W3rhIW31hjWqFkpKkvSfLVM3EO1XVOlNTUIKQkPZ7LWxgv4zKIH7c5nPF2GiZiH6hby8vvDFCr6WlGQ8aiHrHMFv50+Ou8XyR+/9p5Itr+1M46FIb18vjWeTidkM1z1Ain/1Ndrg5Xm4+3PWZ/5FO1qZEqWdzgWASKnO2dslIOIKKEc3b4J/uiS2i/pc9EYwYzGE5/4O6pE+DDmPoHfwjXAxwRPGfQsV72mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 18.7.68.33) smtp.rcpttodomain=redhat.com smtp.mailfrom=alum.mit.edu;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=alum.mit.edu;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alum.mit.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TvQhom1lK7kmCmnzrZb0tL5hjnrdJVuho/xJ5IQmVQY=;
 b=PolkIkGVPshLIO874VzXGuZctU6nzdTmpBO93GPfJMK1G58PuyQiTxTFsApIQPRDyJ7y+rm0Ct3LJWlQ/Y+7VbxEELBpefSsClMQSJZJ7e5dW0CsQwpbiJ+fRhQo2O/2t7TQhzD5shILEZDYI4AgfbNpDf5leYJyWOmmGalF1MQ=
Received: from DM6PR02CA0158.namprd02.prod.outlook.com (2603:10b6:5:332::25)
 by IA1PR12MB7709.namprd12.prod.outlook.com (2603:10b6:208:423::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.41; Fri, 6 Oct
 2023 16:42:53 +0000
Received: from DS1PEPF00017094.namprd03.prod.outlook.com
 (2603:10b6:5:332:cafe::44) by DM6PR02CA0158.outlook.office365.com
 (2603:10b6:5:332::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.30 via Frontend
 Transport; Fri, 6 Oct 2023 16:42:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 18.7.68.33)
 smtp.mailfrom=alum.mit.edu; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=alum.mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of alum.mit.edu designates
 18.7.68.33 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.7.68.33; helo=outgoing-alum.mit.edu; pr=C
Received: from outgoing-alum.mit.edu (18.7.68.33) by
 DS1PEPF00017094.mail.protection.outlook.com (10.167.17.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Fri, 6 Oct 2023 16:42:52 +0000
Received: from charles (c-24-218-5-141.hsd1.ma.comcast.net [24.218.5.141])
        (authenticated bits=0)
        (User authenticated as ryan.hendrickson@ALUM.MIT.EDU)
        by outgoing-alum.mit.edu (8.14.7/8.12.4) with ESMTP id 396Ggonl011029
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 6 Oct 2023 12:42:50 -0400
Date:   Fri, 6 Oct 2023 12:42:49 -0400 (EDT)
From:   Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>
To:     Amir Goldstein <amir73il@gmail.com>
cc:     Sebastian Wick <sebastian.wick@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
In-Reply-To: <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
Message-ID: <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu>
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu> <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com> <20231006130259.GA438068@toolbox> <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323584-1177442978-1696610571=:2758807"
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017094:EE_|IA1PR12MB7709:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f6ceea4-fef7-426e-df99-08dbc68b491a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gEiDgRqU16N6PvNf/NDIktqb1u9a+K6WlIlH4/izcJktZp2AWW26NynPJVFlzT6gcfkM8Quoc+0+pwX9snTuXwi4BCfL7hkHaJutweZwvyVeTsWd+zjL+kavVT9MgglojWEEXh//YB3HUYMejEizNgmjBUHWtmA0jOic+KleV3QgZAhNhuGA/OrwffMDxrwEmOmCWYQxGsP/tlR2Yt6oH+I7+kOWBrOvHJgwiJhNQEzomAtbKJhurpyWsdEXgTdff7vGziqXkN2lyrp3EQC4y6CFMqyUPKVj6P6NHUz9YKL05Rr5oW2HW5/bCYayBJ48at+iKO7E/Vybx9uP2Hkp+3yPscgMvBwIhj3JkWGp+E7Ve9IeZEzMLRCINwMQpXqyFjq/ruDOzMx1DsBHY0Kwxk8PhrGAR26nb7QQ8W+dWuyZS7uMY/msrbqXet83PEOrcxrXD99kdbDVCx8nbrrbDUOr0Cr/oh8iebms249m+RAWqWJfDzhrIRgyQ205ThfInX5LDM//KfMPwVRUgzSapXSy5u7dSFNakJuoNMp6KIGiAVSSS56Qozr0YAOmls2ABH7FachS5j0g56kFyWYqd8tkbi4FLLKB1AE22rN2XNZLSCiUIkoLuqdwPI8X2XJoNIFVy1pXp+e2+fuI8W86l1qHhaZHrjA9ie5GdXceco2VpoSUQR+hPFp88fH3i4GJN9MpwUgHSL9eq50PzPEKJvaKuWDqsYYU7XPInG8AO10dvj2kd6c0qJx6+54JwN8522fRCeA1B0ajsxDgc0kxmA==
X-Forefront-Antispam-Report: CIP:18.7.68.33;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:outgoing-alum.mit.edu;PTR:outgoing-alum.mit.edu;CAT:NONE;SFS:(13230031)(396003)(376002)(346002)(39860400002)(136003)(230922051799003)(82310400011)(8000799017)(451199024)(186009)(64100799003)(1800799009)(46966006)(36840700001)(40470700004)(4326008)(8936002)(8676002)(33964004)(53546011)(41320700001)(5660300002)(44832011)(41300700001)(54906003)(316002)(786003)(6916009)(70586007)(40480700001)(70206006)(478600001)(40460700003)(75432002)(47076005)(2906002)(31686004)(86362001)(31696002)(36860700001)(2616005)(956004)(7596003)(356005)(82740400003)(336012)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: alum.mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2023 16:42:52.7933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6ceea4-fef7-426e-df99-08dbc68b491a
X-MS-Exchange-CrossTenant-Id: 3326b102-c043-408b-a990-b89e477d582f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3326b102-c043-408b-a990-b89e477d582f;Ip=[18.7.68.33];Helo=[outgoing-alum.mit.edu]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF00017094.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7709
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1177442978-1696610571=:2758807
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

At 2023-10-06 19:17+0300, Amir Goldstein <amir73il@gmail.com> sent:

> On Fri, Oct 6, 2023 at 4:03 PM Sebastian Wick 
> <sebastian.wick@redhat.com> wrote:
>>
>> It would be nice to have this fixed. A more general question: will you
>> commit on keeping the escaping stable from now on or do we have to
>> expect changes at any point in the future?
>>
>
> I prefer that escaping would be handled in userspace, now that the new
> mount API allows that, so deferring the question to libmount maintainer.

Note that with overlayfs on the new mount API, there are now two levels of 
escaping to consider:

There is the escaping that needs to happen for commas when splitting mount 
parameters; this could be handled in libmount when using the new API.

And there is the escaping that needs to happen for ':' and '\' when 
parsing the path parameters (':' is only special syntax in lowerdir, but 
the escaping logic seems to apply to upperdir and workdir as well, based 
on my testing). Even using the new API, this is handled in the kernel. 
We'd like to know if this escaping can be considered stable as well, and I 
don't think that's a question for the libmount maintainer.

Thanks,
Ryan
--8323584-1177442978-1696610571=:2758807--
