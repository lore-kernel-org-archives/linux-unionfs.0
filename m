Return-Path: <SRS0=uwCF=6Q=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B42BC47247
	for <linux-unionfs@archiver.kernel.org>; Sat,  2 May 2020 04:11:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5EB321924
	for <linux-unionfs@archiver.kernel.org>; Sat,  2 May 2020 04:11:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="PxVwE+CT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgEBELD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 2 May 2020 00:11:03 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21105 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbgEBELC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 2 May 2020 00:11:02 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1588392647; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=k70wSezh7VjjRj+f4JgL+D8h/AFrocEYDKapwvNDw87GuJtNi+LDVH+ANQfgQt8dCFcR5LH2DzLAmAkQC+h5hOqDtH3ZtHWnSEl4y5qFJXr+RAB+EjOSH3759+0wWCtKTCBDEyW+fwU4xW6W5HLJdoU1HaoJkn9FroyZscglAfQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1588392647; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=LuSHZo4TsUBSckltte9oaeGN4UGgszwbrFwtQ0nFIG4=; 
        b=Tp9yvL1kEGxh4/PX3ctiPwuSsiZZHPiZgslMbqyTVf3fJtmS6AJk4g4hda1GOfl6pidQz6Mv2NBGZ3xWI436sLxj+mtElcXZFJeEgg5qa9gkirBd/0jiUaGd2ZN/l7wYGQM+sB+aq7pvQzLGZkZqHu0vo3OkjO+w84Azdjtg3yo=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1588392647;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=LuSHZo4TsUBSckltte9oaeGN4UGgszwbrFwtQ0nFIG4=;
        b=PxVwE+CT8/jspC5TL/IR/vQyx3MembL2llRQociDD3lD8eZ59fw4V/0F+55MRC30
        Rzr8D53pi2xIJe7vQwclXiU40cqk3Kxz57MsFmt9oO+Gj4HAlATcVDNzwoBK10JSGRz
        ZC4Bq0qdERNPOyZ+pQW/lDatLJFQ+Sgjd9V/xhQk=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1588392644080152.83233939031572; Sat, 2 May 2020 12:10:44 +0800 (CST)
Date:   Sat, 02 May 2020 12:10:44 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "linux-unionfs" <linux-unionfs@vger.kernel.org>,
        "fstests" <fstests@vger.kernel.org>, "miklos" <miklos@szeredi.hu>,
        "guaneryu" <guaneryu@gmail.com>
Message-ID: <171d3944dec.fa74976d195.2610320131996757607@mykernel.net>
In-Reply-To: <CAOQ4uxgVRW9QKVg8edem2OKH1cjLF1+h5YW+nPfkoQg3OiaxgQ@mail.gmail.com>
References: <171ca5e76d2.11a198ab91526.7776557945472155733@mykernel.net> <171ca7ca308.ed1c416b1605.5683082771269054301@mykernel.net> <CAOQ4uxgVRW9QKVg8edem2OKH1cjLF1+h5YW+nPfkoQg3OiaxgQ@mail.gmail.com>
Subject: Re: system hang on a syncfs test with nfs_export enabled
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-30 20:22:06 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Thu, Apr 30, 2020 at 12:48 PM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-30 17:15:20 Cheng=
guang Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
 > >  > Hi
 > >  >
 > >  > I'm doing some tests for my new version of syncfs improvement patch=
 and I found an
 > >  > interesting problem when combining dirty data && godown && nfs_expo=
rt.
 > >  >
 > >  > My expectation  is  Pass or Fail  all tests listed below, Test2 loo=
ks a bit strange and in my
 > >  > opinion there is no strong connection between nfs_export/index and =
dirty data.
 > >  > Any idea?
 > >  >
 > >  >
 > >  > Test env and step like below:
 > >  >
 > >  > Test1:
 > >  > Compile module with nfs_export enabled
 > >  > Run xfstest generic/474   =3D=3D> PASS
 > >  >
 > >  > Test2:
 > >  > Compile module with nfs_export enabled
 > >  > Comment syncfs step in the test
 > >  > Run xfstest generic/474   =3D=3D> Hang
 > >  >
 > >  > Test3:
 > >  > Compile module with nfs_export disabled
 > >  > Run xfstest generic/474   =3D=3D> PASS
 > >  >
 > >  > Test4:
 > >  > Compile module with nfs_export disabled
 > >  > Comment syncfs step in the test
 > >  > Run xfstest generic/474   =3D=3D> FAIL
 > >  >
 > >
 > > Additional information:
 > >
 > > Overlayfs version: latest next branch of miklos tree (5.7-rc2)
 > > Underlying fs: xfs
 > >
 >=20
 > Please test also against 5.7-rc2. Maybe we introduced some
 > regression in -next.
 >=20
 > Please dump waiting processes stack by echo w > /proc/sysrq-trigger
 > to see where in kernel does the test hang.
 >=20
 > I cannot think of anything in nfs_export/index that should affect
 > generic/474, but we will find out soon...
 >=20

I=E2=80=98m on vacation this week and it seems hard to reproduce the proble=
m on my laptop, maybe there were some config problems.
I'll do more analyses next week on my testing machine.


Thanks,
cgxu



