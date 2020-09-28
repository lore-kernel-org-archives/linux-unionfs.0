Return-Path: <SRS0=ILYM=DF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7E7C2D0A8
	for <linux-unionfs@archiver.kernel.org>; Mon, 28 Sep 2020 07:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FFE62080A
	for <linux-unionfs@archiver.kernel.org>; Mon, 28 Sep 2020 07:22:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="rxmiIBRa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgI1HW7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 03:22:59 -0400
Received: from mail-eopbgr80102.outbound.protection.outlook.com ([40.107.8.102]:35126
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725290AbgI1HW6 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 28 Sep 2020 03:22:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbKCCpYvrpD93Kv9e3X4lpJQ88EqukwD+LW7JM1euMgmr6+54Q1V8oOuowEKomUDF+91kLkKh5Fhn25T2vvG2LRpumyw1ECvYOTbAgiDVx3M3FsfysQ20c51t1QBr0NjvfiyJ4oV9l5MnoJ98R4N3MZB8Yf1WXJGBw0nc2YjlLA5JizSRKdUvAS0KwfPh+M4Xw+Q6s9DnltB61tNUMXoO3xGjvCRqrJTYi86OKXuul/HDT2YpeUa7WDj9BcxejKFJUvjxtrK6W7PK7iXAi9ICDi6SBiMyhsbxNxrYcdsNiZuVCUl6aQ3vVVPoNB1QsD7Cfx2DH+njlZ9l7eOG/CaWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zv2/22aVeOxCq90tkdNdyKKPapk1rA02Rt6IXGZ1RM=;
 b=Rn5mFJ+LmFUO+OMqK6qKPmUCndh93BIwutgNcOZEmvPxGEAD3Cji5+LI/HM5MAIMp0HESzzWHc4WYWof3TSIccMDxfvEZ3ROC2WVXuIolHS8y1gwGOkFDS35mf1VFcNejWAT431hWaCp/OgVN3FMWw6vVHLyYwTOZc+9EPTr2kLZ2UhGRpGHvAvVXGD1AxWiJ64gRKRh1Fh8wlY683qX1CMoGOXHOC62ktmnIoPzS967+a1bifIR9frBbDB6J7Ny38hQyfCaoen51s4OJ4Aw5PjsW/2fxLkP0APCBjl5WfRHPKM8Dt8A/6nPP7H6ExfRFoTYNfv0GRAtnez7ZSsWzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zv2/22aVeOxCq90tkdNdyKKPapk1rA02Rt6IXGZ1RM=;
 b=rxmiIBRauTLJQXVo6Hn8sxZJp6nTaGthbNhjgHZ5FRo2Ez7kCYV/3m31mxoLciFb2uMjqCNIQHIdig63xAY4qgrfBQgNZOfe6lAp6bdarL38AI7rqBFmcC4XuwZyaIOXqMPFMiYbhwTfC21tRVOQBS0v6YSoSOIbjLB/uzmqEhQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM6PR08MB3191.eurprd08.prod.outlook.com (2603:10a6:209:41::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Mon, 28 Sep
 2020 07:22:55 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322%7]) with mapi id 15.20.3412.028; Mon, 28 Sep 2020
 07:22:55 +0000
Subject: Re: [PATCH v4 2/2] ovl: introduce new "uuid=off" option for inodes
 index feature
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20200925083507.13603-1-ptikhomirov@virtuozzo.com>
 <20200925083507.13603-3-ptikhomirov@virtuozzo.com>
 <CAOQ4uxgxw7hZysDPfkrE9=Rc8-iK3=3SMX+RQJqgaARFRb_rNA@mail.gmail.com>
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Message-ID: <2d2d19c0-66cd-d823-f63e-92b6629ca3aa@virtuozzo.com>
Date:   Mon, 28 Sep 2020 10:22:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <CAOQ4uxgxw7hZysDPfkrE9=Rc8-iK3=3SMX+RQJqgaARFRb_rNA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0124.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::29) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.192] (46.39.230.109) by AM0PR06CA0124.eurprd06.prod.outlook.com (2603:10a6:208:ab::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Mon, 28 Sep 2020 07:22:54 +0000
X-Originating-IP: [46.39.230.109]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87d206c0-2b10-4b51-6b13-08d8637f5167
X-MS-TrafficTypeDiagnostic: AM6PR08MB3191:
X-Microsoft-Antispam-PRVS: <AM6PR08MB319135CD20102F1F05CCE95CB7350@AM6PR08MB3191.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gk3OFoISGl5UPK3u0ePDwUFSi7eNxe+LHQ69YW+IvrqTaTBFSCgul8ZAG7hsm0gAXeHfmNCvUEFfXLxKxyafOutUQ356UaI2dQf8jQ/JGTbdda1RkTKV57+glSGKqrwcAcwMtmLZDXf7mfaHZFOhmkB+531RoZizfX0czbz40MSgPRXI+BW2rWvg428gjA0tp4spAAPQEo1y/1RQAvjoimkyDcmmWuIgfNuyQyaAAjTVSHelr5fACVN7mnz8XxLHE0sYabJVwUMKcntjnvcas6CLkXNU9CebIoOIV1GSem14+cHP+PN7u3lSYv8XSDpI9zsK6rTyWm+UqkKcVmHTrpDgJ9WrZpD4sZulQibdHnhuewuccMRa7i5ZiWoY4ZfE0YC/h4GuSkHXaJmTJ4AddKNXMHRReqc6eN81g2+vy54=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(39840400004)(346002)(31696002)(8676002)(8936002)(53546011)(186003)(31686004)(16526019)(52116002)(26005)(86362001)(6916009)(6486002)(4326008)(54906003)(558084003)(2906002)(36756003)(16576012)(316002)(66556008)(66476007)(66946007)(478600001)(2616005)(956004)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 7zYSbPSwKyS71S7FSJBTymSVRv6aQufVw/Z69yybl/Rzh5O/2DtFvAg4SNeTJTHHcp7WDALuW9SpNLMJU40r4wat/wTI/j6p4AwM1vSylxgpW8TTHTSKq+xE6IY1+NUZE6uX0uxTgtBXriCsm969A7cLWF1LojtC+kSM24ynAYsu1D2n3NUDmbcmTor1sRCPOB/M5ZlvGvCoTjup/RYEgvrFebLvnuTlThya09TdgGFtHZQS3yPJ8PzQmLsEQf84IIKy8W1vteYg+eSj/iIyLJjKvaNxT7LUeM5+MGpp2w3ZJKInImi4ZIvAE0ClmfZuE2aD2TKHyh1LyT5pYcBFEWXhYRTHaITjEbWBcr2lji/sBsJwmcQ1OTzLs+3GOOWYHM703Pwqg5lLmXlD19XSUiFS3kz2z7pV+02ymJgyQfpEf7ymzDqEs8nut58xhSEzdNIsEyddcp7fcSVPhtM/3QgE37Vutz/6+d16R5t5TBguGCjlE+b83RP6AYtao7hh3zWd/ZHUul8ZFyarftfWURy+0OmFaeJ+spX0eYb6OWJW6kWj909Z0flI4w5lt3XfJa9M7uCgAwJPPwfKBPAeLlt7KeJCyFQXRIanxfWlyk833Mg3KIAC4Q1IvoXWZbaOtKWuNoFQTQzoYZ+dRFQ6UQ==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d206c0-2b10-4b51-6b13-08d8637f5167
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2020 07:22:55.3592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KFvU6VhkhT0krQFrO8vUhJ0sHo9W6fIq+4Uc2OTVtDWwMxAYzPIm2KgZNyIE2Wqb3xkjCzsMAsjfqr60/PUPZmoJlg8lkYtBq6c0g2n9w2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3191
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 9/25/20 7:42 PM, Amir Goldstein wrote:
> Apart from some typos, looks good to me.

Amir, Thanks a lot for your review!

 > you should wait for more feedback from others

Sure, will wait.

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
