Return-Path: <SRS0=0kBH=DA=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F488C2D0E2
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 13:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0146221F0
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Sep 2020 13:31:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="RzPzfWSz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgIWNbh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 09:31:37 -0400
Received: from mail-vi1eur05on2108.outbound.protection.outlook.com ([40.107.21.108]:63904
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726130AbgIWNbh (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Sep 2020 09:31:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRPyMKzhYmccNRKWx1SiPEEK2SeD79by91mFucgO2viSnMjmyR8qljEmO9Nt8liXYp6KXtrXuSJLrNAeZwtn31vSVKINPMYLcqodQvl37u8HFMnT1JsqB/ckgATGJnHclASNue1D48YcjCMmX8vMVjVAhs3JY43S3x8gI4cTUqpYm9rqNhnVUfw+5wJPm0Znh3wtANz/Qxhmkl/ra3BmOghx+PjQtV3HbtHq5ZZNMpTf7/3zXbzw1au0F9U73R/ELXFh1211D2qbUnqhYOuobJ+cmygYlHKc5dwd8ZiifOtJ7HLif233umoXwBBajvVrQRTDOcIqqPAuRg1dnPJxlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIupRd/EPzUkDp+g7Nfn8/uI/iuZ+diBJsG92Ye5TZQ=;
 b=Dy4q5Ep+3tVQWc7v3sQ+uVYAzc6bzXOBl6mLv7xqvrOLVSW34ukL2HQhIXt/AhQRov1L6rvgwU8WhkYstA+A2T730oMn5GpJV6UhTfVKxs/cx+nGcXGwr9ArQeyEH9xw5GfDU6FlmwZAgam5j88RbyN6BOBhOoLLtSjRl/5FtBpY7ywilsbaVafF8D3ZWDk+9SFpRrB77HIYL/Z1Uomj8YoVgsT4XjGFs5rZJpLlSBk5Eu1RFmDLFqnuhjE7ZE9EwKP9uoIp4UGyL3T29+HZPCptT347dgC8XTlCc7TKL693D4F0x0AQ5XYJE4s2LxDos7mxg13fUwiKFl3eGPt2ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIupRd/EPzUkDp+g7Nfn8/uI/iuZ+diBJsG92Ye5TZQ=;
 b=RzPzfWSzsk/dQqWhKxSn+7cze6wHvEjdIL4XtfWkgpVVSTvieWL2yJpnEjdbFmfIWkU7Dft6KouztioJRWzQeLcbZleBRG7MRDRIcqPyxXho7OZpxZoLLjgRZ0yG9IbIMi3L9dleX1OxpH4ltVzIjIlmH2nrp2Mf3qLWuwddSTo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com (2603:10a6:20b:cd::17)
 by AM5PR0801MB1794.eurprd08.prod.outlook.com (2603:10a6:203:2e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 23 Sep
 2020 13:31:33 +0000
Received: from AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322]) by AM6PR08MB4756.eurprd08.prod.outlook.com
 ([fe80::71e0:46d9:2c06:2322%7]) with mapi id 15.20.3391.027; Wed, 23 Sep 2020
 13:31:33 +0000
Subject: Re: [PATCH] ovl: introduce new "index=nouuid" option for inodes index
 feature
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200923125014.181931-1-ptikhomirov@virtuozzo.com>
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Message-ID: <a50e08f1-953d-d8c0-9f29-821eccb9bf8f@virtuozzo.com>
Date:   Wed, 23 Sep 2020 16:31:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
In-Reply-To: <20200923125014.181931-1-ptikhomirov@virtuozzo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0165.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::34) To AM6PR08MB4756.eurprd08.prod.outlook.com
 (2603:10a6:20b:cd::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.41] (95.179.127.150) by AM0PR01CA0165.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Wed, 23 Sep 2020 13:31:32 +0000
X-Originating-IP: [95.179.127.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0bcbb3b-6fe0-4c47-99af-08d85fc4fc96
X-MS-TrafficTypeDiagnostic: AM5PR0801MB1794:
X-Microsoft-Antispam-PRVS: <AM5PR0801MB1794BBAEFF5B89FAF598F2D6B7380@AM5PR0801MB1794.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OjwHhJnlQIqbqs/2su33dQRo42+TAMEw+yTYU0A3CTwxD6JqcA/v7YkmNOP99ZmOwMxigFKxn0PYZsOpYVdZuYVcgQ7oY440RfPUMv9osNZ+lDIrQrP/Z3Nau3UImJAlArzjHHa6TUbt143mNzbrnJsGk8N0vSk1j/06mpc0KHi1kuK8X58aXzRZBJQfuTK9h9kDe1pR6lCzryvb52NjuON7TErU0Vcjw5zCbQFPmh/Ww6mCI4+UCMtdxNl+i3pQnKqCn+KjkpVJZCGvBomDFHKGNvpuJwk7EGM4v1OJTxIrGVd9VUAXzqZ9RzGw9dBZjPIeFEXT+dfMUDjInBVZw/Jk1U0n0PVBAtskqtUQQpQt2al8FGSnGNY81O7iON17
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4756.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(366004)(396003)(376002)(136003)(346002)(2906002)(52116002)(16576012)(956004)(2616005)(31686004)(316002)(5660300002)(53546011)(26005)(186003)(16526019)(36756003)(66946007)(54906003)(31696002)(6916009)(86362001)(8936002)(6486002)(66556008)(4326008)(66476007)(478600001)(6666004)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: qLYN/snFEwN3gaBIIB0WtFx0q7SFIu9lb95hS5Tv/qLEGfgsh//ZkK4nkElQhQEcHy4y9KKpi6j3k8POqVJboeW3bBnQvTWh8RpHHfVnAgkzlhRs4YLxOlGxQBMD9wSZVe/SzS+3K/HzygxOiIMdFzKka1sDYZv3kMQIvWPAiS++86f0AfMCBawyEBJVCn7X5ETy2cVxrL+TrvrSGfXJ2TwkiPodl1ZvBhCMh3TBsK+Rz7rZ7XloI92Cwx/Sql3Q0F7jfEbVDQxmtUzKtjnU6LQTAKth57CEzYpVGrH/JM1jQFHIHD34a5eFJZ17GPpneBk+OOzrc75Nys3g5cDTBLzUJeVnkWhHqT1Zsw+h5FdFyf+09h+v+9MlkRUvpQkKbEONBltp1ZcLAJcYpRmKT2LVbmhqKj6aMCch+pySDse5PYCCvzEtj1ZXyko1BFk1pef5UFfrxRKkoSKxNOhNtv06gQuCA3K0ag48blWzFwwZgNHRs1m1wywuS4+ULnnyKuY22QKuM5nIq+y5rl/0HXgCW1A7XndOE7Ejt+Yr/TS9qxKNYP+1sA/502V4XreW6RO265qs0WkEwojBOK5RHcRXY1g5CGyAAbuCWDlqwcGH+B4mEUza9ixxucgs7esbgwmaPDoiB+ubEFGKaMQjRw==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0bcbb3b-6fe0-4c47-99af-08d85fc4fc96
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4756.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2020 13:31:33.0541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ARd1zfhV6zS6XWbB7CFubed7hXiOFPJXU+bKLG6G0tsoSmzgTbdQkpJnPk+dI/tCBJD9w5DnOFvCXXV1+MgL9JmEfbieigW48F5XBiEJeDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB1794
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Please drop, I accidentally missed several hunks...

On 9/23/20 3:50 PM, Pavel Tikhomirov wrote:
> dd if=/dev/zero of=loopbackfile.img bs=100M count=10
> losetup -fP loopbackfile.img
> losetup -a
>    #/dev/loop0: [64768]:35 (/loop-test/loopbackfile.img)
> mkfs.ext4 /root/loopbackfile.img
> mkdir loop-mp
> mount -o loop /dev/loop0 loop-mp
> mkdir loop-mp/{lower,upper,work,merged}
> mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
> upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
> umount loop-mp/merged
> umount loop-mp
> e2fsck -f /dev/loop0
> tune2fs -U random /dev/loop0
> 
> mount -o loop /dev/loop0 loop-mp
> mount -t overlay overlay -oindex=on,lowerdir=loop-mp/lower,\
> upperdir=loop-mp/upper,workdir=loop-mp/work loop-mp/merged
>    #mount: /loop-test/loop-mp/merged:
>    #mount(2) system call failed: Stale file handle.
> 
> If you just change the uuid of the backing filesystem, overlay is not
> mounting any more. In Virtuozzo we copy container disks (ploops) when
> crate the copy of container and we require fs uuid to be uniq for a new
> container.

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
