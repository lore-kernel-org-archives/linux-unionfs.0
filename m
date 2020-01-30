Return-Path: <SRS0=QbUM=3T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CEAC33C9E
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Jan 2020 03:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F026D206D5
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Jan 2020 03:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgA3DcW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 22:32:22 -0500
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25347 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726485AbgA3DcW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Jan 2020 22:32:22 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jan 2020 22:32:20 EST
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1580354223117734.9393452627133; Thu, 30 Jan 2020 11:17:03 +0800 (CST)
Date:   Thu, 30 Jan 2020 11:17:03 +0800
From:   admin <cgxu519@zoho.com.cn>
Reply-To: cgxu519@mykernel.net
To:     "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "linux-unionfs" <linux-unionfs@vger.kernel.org>
Message-ID: <16ff473bc09.e9ea67252776.7817870406116452896@zoho.com.cn>
In-Reply-To: <CAJfpegv949oJAZQNjTsq5MQHz6LLkfihp4S_mWRuYsLRuPCgFg@mail.gmail.com>
References: <16d7200e45c.1398c37e020790.5506577327176178828@zoho.com.cn> <CAJfpegv949oJAZQNjTsq5MQHz6LLkfihp4S_mWRuYsLRuPCgFg@mail.gmail.com>
Subject: Re: syncfs improvement for overlayfs
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- 在 星期五, 2020-01-24 22:21:38 Miklos Szeredi <miklos@szeredi.hu> 撰写 ----
 > On Fri, Sep 27, 2019 at 11:15 AM admin <cgxu519@zoho.com.cn> wrote:
 > >
 > > Hi Miklos,
 > >
 > > It's been a while since I posted my last version of syncfs improvement patch[1]
 > > and I noticed it isn't get merged yet. If you think this patch is still valuable then
 > > I would like to do rebase on latest overlayfs tree and resend for review.
 > > What do you think?
 > 
 > 
 > Hi,
 > 
 > Sorry, this has fallen off my radar.  Can you please rebase and resend?
 > 

Thanks for your response, I'll do it soon.

Chengguang

