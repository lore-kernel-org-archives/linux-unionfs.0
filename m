Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35660C433E9
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Jan 2021 06:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14D8621D79
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Jan 2021 06:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbhADG4x (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 01:56:53 -0500
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25313 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728050AbhADG4w (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Jan 2021 01:56:52 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1609743325; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=P+Q/YiefMdil8Dckbpfpvmyou7VioMVPuatsZAAxo0sIi4+dZiUUvoByh7WQOKJlzE1IIRUTO+aKvM1irihH+5reBTWORL0aOPw+ASDoTjydvrdQ5RvJf0fcMeaT3QTaiNQz8qSW19a7moUP9Aex5bZ8Ev0g6kJL34G8+oWOO1U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1609743325; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=l9QaRr1wUC4676MqLnM2embVQckM4BrmJHSPMqUeC9Y=; 
        b=NQmYRsQ+/ShJSld/D2zgthG+r4knDGy6+Pld4lbiJzIXzv4VxCN9tCqwhGFQlk7GsENrtNQoPe05yYUL3hBM3z1tPo+NTfCjrFl8uvoUhE788XvmW7n9VvjZu1TiXDshuGgj3VHKHWgwPD3v23UF7+tYIrPHLaqVogrX528G9j8=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1609743325;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=l9QaRr1wUC4676MqLnM2embVQckM4BrmJHSPMqUeC9Y=;
        b=Rgrx3ZUsl6zMYsywL+vSv38pVNCLkP38kBgfodVjGQfN7Ik3wUcdihIXypN+rrSj
        DPjfnzQUY0T7SudvHUHFSQS2t9E3gox4OnSuVEV/FQicClaGE8V/4CJm+14oqQsebK2
        deot4K7Mf0U+IezVAhHzkK+8PYnp6W93GGRsTWSI=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1609743322436895.3931952908997; Mon, 4 Jan 2021 14:55:22 +0800 (CST)
Date:   Mon, 04 Jan 2021 14:55:22 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>,
        "Miklos Szeredi" <miklos@szeredi.hu>
Cc:     "overlayfs" <linux-unionfs@vger.kernel.org>,
        "Vivek Goyal" <vgoyal@redhat.com>
Message-ID: <176cc2dcd40.107ad48cf41153.6757897875754439646@mykernel.net>
In-Reply-To: <CAOQ4uxhn1q4ZcW+GgNxLwcSwhQxrQJibPhX8xO2YsbS1et6YiQ@mail.gmail.com>
References: <20201226104618.239739-1-cgxu519@mykernel.net> <CAOQ4uxhn1q4ZcW+GgNxLwcSwhQxrQJibPhX8xO2YsbS1et6YiQ@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: keep some file attrubutions after copy-up
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=80, 2021-01-04 13:04:56 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Sat, Dec 26, 2020 at 12:48 PM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
 > >
 > > Currently after copy-up, upper file will lose most of file
 > > attributions except copy-up triggered by setting fsflags.
 > > Because ioctl operation of underlying file systems does not
 > > expect calling from kernel component, it seems hard to
 > > copy fsflags during copy-up.
 > >
 > > Overlayfs keeps limited attributions(append-only, etc) in it's
 > > inode flags after successfully updating attributions. so ater
 > > copy-up, lsattr(1) does not show correct result but overlayfs
 > > can still prohibit ramdom write for those files which originally
 > > have append-only attribution. However, recently I found this
 > > protection can be easily broken in below operations.
 > >
 > > 1, Set append attribution to lower file.
 > > 2, Mount overlayfs.
 > > 3, Trigger copy-up by data append.
 > > 4, Set noatime attributtion to the file.
 > > 5, The file is random writable.
 > >
 > > This patch tries to keep some file attributions after copy-up
 > > so that overlayfs keeps compatible behavior with local filesystem
 > > as much as possible.
 > >
 >=20
 > This approach seems quite wrong.
 > For one thing, mount cycle overlay or drop caches will result in loss
 > of append only flag after copy-up, so this is not a security fix.
 >=20

You are right, I overlooked the case of dropping cache.

 > Second, Miklos has already proposed a much more profound change
 > to address this and similar issues [1] and he has already made some
 > changes to ioctl handler to master doesn't have ovl_iflags_to_fsflags().
 >=20
 > [1] https://lore.kernel.org/linux-fsdevel/20201123141207.GC327006@miu.pi=
liscsaba.redhat.com/
 >=20
 > One more thing.
 > It seems like ovl_copyflags() in ovl_inode_init() would have been better
 > to copy from ovl_inode_realdata() inode instead of ovl_inode_real().
 > This way, copy up still loses the append-only flag, but metacopy up
 > does not. So at least for the common use case of containers that
 > chown -R won't cause losing all the file flags.

IIUC, the flags will still keep in overlayfs' inode after copy up until=20
the inode cleaned by dropping cache. So I think your suggestion will be
helpful for the case of meta-copyup & dropping cache.

Hi Miklos

Is it worth to change like above?


 >=20
 > ovl_ioctl_set_flags() triggers data copy up, so that will break the link
 > to lower flags anyway.

I think though ovl_ioctl_set_flags() triggers data copy up but the flags
will be set correctly to upper file, because chattr(1) will get the flags
first and set the whole flags(include original flags) to upper file.

Thanks,
Chengguang

