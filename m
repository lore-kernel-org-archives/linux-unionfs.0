Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95046E776CE
	for <linux-unionfs@archiver.kernel.org>; Mon,  2 Oct 2023 22:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjJBWXE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 2 Oct 2023 18:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjJBWXE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Oct 2023 18:23:04 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2066.outbound.protection.outlook.com [40.107.101.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C194891
        for <linux-unionfs@vger.kernel.org>; Mon,  2 Oct 2023 15:23:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDzztLs6YURRufR/YhwsczeUncqILNrVKxLCRsgOobfH1AjQG/MbaxERUR6tyOwpAm6XWFIWbizB3BCAfsalD3Wns6bQfSQgYYawQvAxTN14AziTKwcS3zWbPcxpN0yeZ3cNI0AoGIQuGKoXTw6GUZ8tEgLZ0WjLfYG9n3hiEQxssTYZJxung3ZDcErFshbj5/gvIN+aihU7s6gMBFSwyZPYIfoy5C+p/dBRam78CuBCX10GDYs7hDH5NMxSXFhSoc40DtMxbnClZ5ZFwk05YrB6nuzT/Hw7w+RMgqxNNoy2t5Q522NFG/A8MQtoIfj4w5cyc56WpVdHoSbM0UHv6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7LB1Ok+0X6OBGzLHeAEH1cMtDJbyAAJNN6tiE4eRjvE=;
 b=CdpQ/+VC0y+qAhQdtN4pvIxLuJLMCyD4PishtW/03s4hSqQ9WL1KcYjZ2x4DxF1A/5s2T79Y6cKnPHy05uw1DAV1Mr8FU1RsFR3vEtKgZeBP+jCJFOmnWwTSgpY0LkcniegpRGX9kaWS859TgL/zpzH3MFFHAMT4Cvh4TnCiCt9qOTCaBo8WaqFDPyLZNBkwWJ6AlevhFjzylvEx9VRIfBF/VdJP7gx81tzPzylh02w6f1wN5Dp0sT7LUiYGuSbzPiSeA5SECuFcNGJTxMiF3Jeu46lQqp+A07Qt0Ns3oO44kOXJb3h7ryaF1pdEAWaE1Lbt0vwjF9XKSfKKjQcYgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 18.7.68.33) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=alum.mit.edu;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=alum.mit.edu;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alum.mit.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LB1Ok+0X6OBGzLHeAEH1cMtDJbyAAJNN6tiE4eRjvE=;
 b=D6S1Uf63kXU76vRBJ3oyBXi07sjwTaKlzDVPMvauUPD4wCFX8dhFgDQG8irTPQojNiGA9K5mK11l1YGGberYRzayhEa7TDemjrkwFFRcU4NSpeO++YscRIdddn62SERIS0khNADg+5UpvdtE//EtqcUT21mfMYclOI4G1IIPBw0=
Received: from CY5PR15CA0046.namprd15.prod.outlook.com (2603:10b6:930:1b::7)
 by MW6PR12MB9020.namprd12.prod.outlook.com (2603:10b6:303:240::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.28; Mon, 2 Oct
 2023 22:22:58 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:930:1b:cafe::f4) by CY5PR15CA0046.outlook.office365.com
 (2603:10b6:930:1b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.31 via Frontend
 Transport; Mon, 2 Oct 2023 22:22:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 18.7.68.33)
 smtp.mailfrom=alum.mit.edu; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=alum.mit.edu;
Received-SPF: Pass (protection.outlook.com: domain of alum.mit.edu designates
 18.7.68.33 as permitted sender) receiver=protection.outlook.com;
 client-ip=18.7.68.33; helo=outgoing-alum.mit.edu; pr=C
Received: from outgoing-alum.mit.edu (18.7.68.33) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.14 via Frontend Transport; Mon, 2 Oct 2023 22:22:56 +0000
Received: from charles (c-24-218-5-141.hsd1.ct.comcast.net [24.218.5.141])
        (authenticated bits=0)
        (User authenticated as ryan.hendrickson@ALUM.MIT.EDU)
        by outgoing-alum.mit.edu (8.14.7/8.12.4) with ESMTP id 392MMsa3028172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 2 Oct 2023 18:22:54 -0400
Date:   Mon, 2 Oct 2023 18:22:53 -0400 (EDT)
From:   Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>
To:     Amir Goldstein <amir73il@gmail.com>
cc:     Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org
Subject: Re: [regression?] escaping commas in overlayfs mount options
In-Reply-To: <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
Message-ID: <80c265ab-1871-211e-2787-fefbf25a892a@alum.mit.edu>
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu> <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|MW6PR12MB9020:EE_
X-MS-Office365-Filtering-Correlation-Id: f9795297-cfac-44d8-d4da-08dbc3962122
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kUhNeDF8z+LwBkJQKSxwRMuSEO9nfDULkfb1Qd1kWYCShIikil9iMWrWCLAZnCPkXLemYqPfTlnRhzkqQRiaixskhwNiLsNqkEotleInYWNQchlmTxzEv3Jtm7tlnuZlsUBWrBOBHCzOoKlEK/9U4qqrPdj6dbj53Z/+C4rK0TACfANNW4VN9LSdNf+yn/+Xb0APGJdxxqy31F0js/EQ4JklEb3QhEHKnUdge22LBzWBfJcNAOehN5qb16lD32TH7g6EEkHXq8PdGRot7paY8g2/MAvM/CYIzX5V/uS8TwC2zX8qd2FwWsxhUlEsBUWDF5Kus3Vv57VbAn6+/vUanNbDyg5gIfUWcUfQ3gqGS8fpPLbR7Qifg4JjGAJ3LwBpm1yv/f0ga/Qxx+gMVPZGW/kl/B+YeHZo7GO+ECSfzqJoJCgmH90xO8Pffb9W0HleR15BxSV5fV9uYuWa+99a2rsW3iP0kZgisAZVBuj19f2H1XaCg2OlJm2BMWEEyrbiQkf5anu33PYhtcroklBv1OLVLscvvIR3cuhLOufbfIK9J977R+E3h78Dn1zp5oxoZQwFegjFpAx5S5V8I/Tz281IfKUnhrARJ7eW1jAKQji9MpAr0K90MrjyFYVBLqCsdCQwKIuYUer3orEmNdJaLjRt41lR4OE58gL8MJhEwd8s8WLxXkGMrbL4OR6XNnxtjUS+gaq1Y6DgEl+FXIbFzaVuvqnhgqplw87hwdLmozukgW5KDze8pspx5hq1PLVxmGsvrXsbojE01QV824JGcA==
X-Forefront-Antispam-Report: CIP:18.7.68.33;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:outgoing-alum.mit.edu;PTR:outgoing-alum.mit.edu;CAT:NONE;SFS:(13230031)(346002)(136003)(396003)(376002)(39860400002)(230922051799003)(8000799017)(1800799009)(82310400011)(451199024)(186009)(64100799003)(40470700004)(36840700001)(46966006)(31686004)(40460700003)(2906002)(5660300002)(75432002)(8936002)(4326008)(8676002)(44832011)(40480700001)(316002)(54906003)(41300700001)(31696002)(70206006)(956004)(70586007)(86362001)(478600001)(6916009)(2616005)(786003)(82740400003)(336012)(26005)(41320700001)(7596003)(356005)(83380400001)(47076005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: alum.mit.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2023 22:22:56.7592
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9795297-cfac-44d8-d4da-08dbc3962122
X-MS-Exchange-CrossTenant-Id: 3326b102-c043-408b-a990-b89e477d582f
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3326b102-c043-408b-a990-b89e477d582f;Ip=[18.7.68.33];Helo=[outgoing-alum.mit.edu]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9020
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

At 2023-09-29 07:44+0300, Amir Goldstein <amir73il@gmail.com> sent:

> That's a good guess.
> It helps to CC the author of the patch in this case ;-)

Ha, oops! Sorry, I have been spoiled by web-based bug reporting interfaces 
and actually e-mailing maintainers is weirdly a novel experience.

> The question is whether we should fix it.
> The rule of thumb is that if users complain than we need to fix it,
> but it's a corner case and if the only users that complained are willing
> to work around the problem (hint hint) then we may not need to fix it.

Gotcha. In my specific situation, unless there is an alternate escaping 
mechanism or mount API that works identically in both <6.5 and >=6.5, I'm 
going to have to do some version detection to work around the regression 
in released 6.5 kernels regardless of whether the old functionality is 
restored later. As long as there is *some* way of using overlayfs with 
arbitrary path nemes (including commas), I'm fine with whatever you 
decide. (If there isn't currently a way to mount a path with commas in it, 
you may consider me complaining.)

But if the status quo remains, I would like an answer to:

>> Is there a new way to escape commas for overlayfs options?
>>
>
> Deferring the question to Christian.

BTW, in case there's a difference between them, the actual code I'm 
working with uses the libc mount() function, not the mount CLI tool. I've 
also experimented with the functions in libmount but they seems to have 
the same problem with commas. Either is fine as long as I can support 
mounting arbitrary path names.

Thanks,
Ryan
