Return-Path: <SRS0=Y/ci=AG=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E56C433DF
	for <linux-unionfs@archiver.kernel.org>; Thu, 25 Jun 2020 09:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F6820679
	for <linux-unionfs@archiver.kernel.org>; Thu, 25 Jun 2020 09:46:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="Uy3KVqLy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403887AbgFYJqv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 05:46:51 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17155 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403870AbgFYJqv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 Jun 2020 05:46:51 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1593078386; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=EgH0xgwSAKduymr43/rVGQ4MkTDrKxd2jzcjGhI9szprvGq7sA6ubQRi3SXe+qvXN8QJDtVPeMRb7LQbK11fUYtEJS5vbUA83TwZI011TFyvTqy/w6Hb/3WMxlkwqTmcZ8cYUBfq33mzzuaNji60+Zx/ogt1azFBIgUQPjvLiZc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1593078386; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=cWTbJizeyzdRgoh0Uc4ok/PLq5mJDXP+eq9lt4pg+b4=; 
        b=IBmSk1Hhxl0G0qBcFNBVx1x75QOJDmYJEi79rvbaQq3l4OXHtU2tfLtSHWDByBPc3X0aCz+/UC4crJXj8C5scrUGZAp6FyNrB3RCc95u8OsWczTWdyV5jtplqLpJlAE/EehFJImHVk/Kw8r+YNrzWYXNiD9Vk/hQSY01dHJ6w4g=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1593078386;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=cWTbJizeyzdRgoh0Uc4ok/PLq5mJDXP+eq9lt4pg+b4=;
        b=Uy3KVqLyg/tqRAD8VXlMVeliRQ+6488MS2RY5LBCtJp/8Qz2lDPSy0yGR9JX3iLP
        Y1xFxVssJjPURZlT0BzSRby/AOtaUURs9qpEOS+FZ9yK66z2w95DoSEZkhox56iaC7J
        SqpZCrlNIcIuZjgmnWpA08DHr5pmh7p9Dm/T11Do=
Received: from [10.0.0.11] (116.30.194.71 [116.30.194.71]) by mx.zoho.com.cn
        with SMTPS id 1593078383047614.5691548687388; Thu, 25 Jun 2020 17:46:23 +0800 (CST)
Subject: Re: [PATCH] ovl: fix incorrect extent info in metacopy case
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
References: <20200624102011.4861-1-cgxu519@mykernel.net>
 <CAOQ4uxi53CzBwXxygKMhDDSaGpX0CcfV6jiaKRFVbrFHW7PbxA@mail.gmail.com>
 <CAOQ4uxh9gzdRJp4g1yjQy9nDMASdsdvkzBGhGL2_+3rOBJZFAw@mail.gmail.com>
From:   cgxu <cgxu519@mykernel.net>
Message-ID: <9cecb52b-620b-69c1-059f-f782b946da1a@mykernel.net>
Date:   Thu, 25 Jun 2020 17:46:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxh9gzdRJp4g1yjQy9nDMASdsdvkzBGhGL2_+3rOBJZFAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ZohoCNMailClient: External
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 6/25/20 4:35 PM, Amir Goldstein wrote:
> On Wed, Jun 24, 2020 at 3:53 PM Amir Goldstein <amir73il@gmail.com> wrote:
>> On Wed, Jun 24, 2020 at 1:23 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>>> In metacopy case, we should use ovl_inode_realdata() instead of
>>> ovl_inode_real() to get real inode which has data, so that
>>> we can get correct information of extentes in ->fiemap operation.
>>>
>>> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>> looks right
> Miklos,
>
> Not related to this patch, I noticed something that could be odd with
> ovl_fiemap().
>
> When passed the flag FIEMAP_FLAG_SYNC, ->fiemap() will trigger writeback
> of lower inode pages.
>
> This behavior is border line for overlayfs.
> I did not check if filemap_write_and_wait() ends up being a noop on read-only
> fs or if it can return an error.

vfs ioctl does the same behavior regardless of read-only fs and IIUC,
writeback functions will do DIRTY tag check before actually sync dirty data.

Thanks,
cgxu

> Following ovl_fsync() practice, we may want to silently drop the
> FIEMAP_FLAG_SYNC flag? but that could result in unexpected results.
>
> Am I overthinking this?
>
> Thanks,
> Amir.

