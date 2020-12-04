Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB44C4361A
	for <linux-unionfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 996C722B3B
	for <linux-unionfs@archiver.kernel.org>; Fri,  4 Dec 2020 14:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbgLDOvB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 09:51:01 -0500
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25361 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728722AbgLDOvA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 4 Dec 2020 09:51:00 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1607093355; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=ndNANPUWVGfHucMJ5xQ1emLLGzI3+wuAz5H+8qJpHa5bTN8majf3mSf3YbkrQ6lhS5FFvCYCJAW2Xp+3Yudf8dthbAuwHjyRcHKq0n0DIYwm2Jrn22pgBESbfcYebMO990Msxt0GsHRp2Dn4yWjM2jBnVzjA7Q+/B2CoBWJtRwQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1607093355; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=kK7fm3U7tpTOpXFsGow3ABcz6r3U5ljVsnieNyOaatw=; 
        b=Eej7qJMlZ/5r1/4nwPgt1f7uVC3LBG8wAKZjXTTd1BCZ1j1F1gf11hNl2CmwwtlBYmRkIIcOYn6GDCaX3aoCEPaT8i/x9JP2WfheGh3EVK2bjT8I3P3b64qtIej3nX1x15vVof0VXpIikt9w5lF4yCFsnQn6HvvTkyjiDqRGvyU=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1607093355;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=kK7fm3U7tpTOpXFsGow3ABcz6r3U5ljVsnieNyOaatw=;
        b=SVWdB2tRSkHPq1mhWjORMC0sGmLjXLvAYXGyx2JcDK3t3P/Hjnc3xM3bCtTZsjhL
        NRhNiK4s0kgom4ueUrWcojBXWwR0k/aGKoZzF5rk6eBX1n/imCeBau4ncGxtUHV2+CK
        R2FXDoX0HeVT0SLuz0z/k4MrlhhB6Hy6NtmC2Fkc=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1607093353424301.2005109054902; Fri, 4 Dec 2020 22:49:13 +0800 (CST)
Date:   Fri, 04 Dec 2020 22:49:13 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "miklos" <miklos@szeredi.hu>, "jack" <jack@suse.cz>,
        "amir73il" <amir73il@gmail.com>
Cc:     "linux-unionfs" <linux-unionfs@vger.kernel.org>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
        "Chengguang Xu" <cgxu519@mykernel.net>
Message-ID: <1762e3a7bce.e28cb82145070.9060345012556073676@mykernel.net>
In-Reply-To: <20201113065555.147276-1-cgxu519@mykernel.net>
References: <20201113065555.147276-1-cgxu519@mykernel.net>
Subject: =?UTF-8?Q?=E5=9B=9E=E5=A4=8D:[RFC_PATCH_v4_0/9]_implement_c?=
 =?UTF-8?Q?ontainerized_syncfs_for_overlayfs?=
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-11-13 14:55:46 Chengguang=
 Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
 > Current syncfs(2) syscall on overlayfs just calls sync_filesystem()
 > on upper_sb to synchronize whole dirty inodes in upper filesystem
 > regardless of the overlay ownership of the inode. In the use case of
 > container, when multiple containers using the same underlying upper
 > filesystem, it has some shortcomings as below.
 >=20
 > (1) Performance
 > Synchronization is probably heavy because it actually syncs unnecessary
 > inodes for target overlayfs.
 >=20
 > (2) Interference
 > Unplanned synchronization will probably impact IO performance of
 > unrelated container processes on the other overlayfs.
 >=20
 > This series try to implement containerized syncfs for overlayfs so that
 > only sync target dirty upper inodes which are belong to specific overlay=
fs
 > instance. By doing this, it is able to reduce cost of synchronization an=
d
 > will not seriously impact IO performance of unrelated processes.
=20
Hi Miklos,

I think this version has addressed all previous issues and comments from Ja=
ck
and Amir.  Have you got time to review this patch series?

Thanks,
Chengguang
