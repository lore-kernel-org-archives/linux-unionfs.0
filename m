Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46969C2B9F4
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Jun 2021 16:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CD1F61027
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Jun 2021 16:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhFVQcp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Jun 2021 12:32:45 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17284 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229826AbhFVQco (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Jun 2021 12:32:44 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jun 2021 12:32:43 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1624378517; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=T0eO6Yt7upYbO64AOwiWcaQpHeMM8q+jjur2gvMRRSprP9DSICqsaqym1QK+wXRpx2HCfTqdIItFB88IMPuOGhyLqk18PkXLYlkHt9qUTy6YO9RIgYbZOznvDa6GUWIt/8PgEQW5OPgdmNscICZEexO9PhZSmaDliqEctG0+xK8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1624378517; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=SQaF6tlpq5w8mTMwzTARaEvMKVjyaCfq7IIu5V4jnuQ=; 
        b=U3gXW8CmX0P9awP5a9oq82pkVzYG6tO4smwVLC5kLJGwfbMvNN6fDj76SQh27DlOZkt8jXJhr0ORAWyNuNN59IdLt2mBF/S5ubyGQTCVTr8yO35mehjyebwZJD3B2AC/ABcFppqe3DifXfV+5Gb4ekNEN2lliN7FltztDQgUMXg=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1624378517;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Message-ID:In-Reply-To:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=SQaF6tlpq5w8mTMwzTARaEvMKVjyaCfq7IIu5V4jnuQ=;
        b=E8fRBi4noPv576rFoAA61mKyevsfBZDYEVEmkIITFjcjQ2lcdCpPvogTtwhP76/y
        bhaakz4HOKqpE9i7JBeS7rnPD2uGy1RcvmvLmdIXuAdw64AbXGG0e+/boZNPaJrv5U+
        CBdUifVBBdxWXMP8Xy47lbiRM7CsiacRavoxi0Yw=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1624378514356732.0285783630529; Wed, 23 Jun 2021 00:15:14 +0800 (CST)
Date:   Wed, 23 Jun 2021 00:15:14 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "linux-unionfs" <linux-unionfs@vger.kernel.org>
Message-ID: <17a34811bb1.ca67d1a36094.7925246580859918166@mykernel.net>
In-Reply-To: 
Subject: Mount failure caused by colon/comma characters in the path of
 lower/upper dirs
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hello,

Today I got a mount failure report from a docker developer about special characters in overlayfs lower/upper path.
The root cause is quite straightforward  because overlayfs uses colon/comma as seperator of lowerdir layers and module options.
However, Colon/Comma characters are valid for directory name on linux so some people(especially container users) hope overlayfs
could correctly recognize and handle those directories.

Strengthen option parsing seems a right solution for fixing the issue, what do think for this?



Thanks,
Chengguang Xu



