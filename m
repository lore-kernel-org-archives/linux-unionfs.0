Return-Path: <SRS0=jezc=EP=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A967AC56201
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 10:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1531520789
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 10:04:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="CD1gltoU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbgKIKE2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 05:04:28 -0500
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25386 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729019AbgKIKE2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Nov 2020 05:04:28 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1604916223; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=VhBaVVmgp7JHKm3aFQjR8VCsZnavlwvzb20DDFabmmjQPsC/ZLWsrYCt3sW24A5TjrVWsUErnFCybDMczqiMZBSJKogW3rFzXf4otFKV8LgVeQGnJnX61ZHOiiedeesvzcvYk+Xw5R/Dj/9it5MfqKVwzKnYKQY2/H0hZtKR9BE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1604916223; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=lV8thjv8gvGD34qGZdlhs9WIEOQpb9ocklJfphK9ixc=; 
        b=nVynZ7DriCowrJ8Pukuv1MmJuYcfWk841SpWSsJmtRMhFfQS6IVbbasVIDpTI6JJpyAxXWAqcGvvGdQDHaXTnD4I3GU++BjPvQa9WaGsTJ1qA/OI7dvciWoD3cEhbIRQyLqCn8LRecYQ+bEa9iUz/w0VxgSs7iSFtDV1K9AuzMA=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1604916223;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=lV8thjv8gvGD34qGZdlhs9WIEOQpb9ocklJfphK9ixc=;
        b=CD1gltoUO0d02MBVqntbTukz+1ck0Ujp+FxxFtOVeHq/oP7JGFbe0JZ+zwjjc/Em
        bUUMXKFoLbfuerFFhHmrtpEsDhKkVoxicdJBQUltuf8HU+d9/N9rTiHZwWRBu853Rkz
        YFQtKmr0shXqEn+MTjFLwjhsDBE/5FzLe3oa0zMQ=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1604916221507733.1931180941485; Mon, 9 Nov 2020 18:03:41 +0800 (CST)
Date:   Mon, 09 Nov 2020 18:03:41 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "linux-unionfs" <linux-unionfs@vger.kernel.org>,
        "Ritesh Harjani" <riteshh@linux.ibm.com>
Message-ID: <175ac761640.13224921c2025.358415481223856052@mykernel.net>
In-Reply-To: <CAOQ4uxiGy5iGqMczJqX70UGCP3CNyuqh3KiQWOG9TKj5Hqms-Q@mail.gmail.com>
References: <17596177926.d559c8b77834.5766617584799741474@mykernel.net>
 <CAOQ4uxgpmC_B_uWpnMXDrv9BOQ-rsMxyRTc+qC3dT72sqR8ndg@mail.gmail.com>
 <17597c5dc4e.fb084b178911.1848736071974456771@mykernel.net>
 <CAJfpegu-rqL4-jn9o0+OSj2x+hKS8mLB6GswhL17Ruhb3WuMKg@mail.gmail.com> <1759833fcec.11bebc5a09074.619089384538905286@mykernel.net> <CAOQ4uxiGy5iGqMczJqX70UGCP3CNyuqh3KiQWOG9TKj5Hqms-Q@mail.gmail.com>
Subject: Re: a question about opening file
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-11-05 22:05:26 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Thu, Nov 5, 2020 at 1:39 PM Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-11-05 17:57:15 Miklo=
s Szeredi <miklos@szeredi.hu> =E6=92=B0=E5=86=99 ----
 > >  > On Thu, Nov 5, 2020 at 10:38 AM Chengguang Xu <cgxu519@mykernel.net=
> wrote:
 > >  > >
 > >  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-11-05 16:07:26 =
Amir Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > >  > On Thu, Nov 5, 2020 at 6:39 AM Chengguang Xu <cgxu519@mykernel=
.net> wrote:
 > >  > >  > >
 > >  > >  > > Hello,
 > >  > >  > >
 > >  > >  > > I have a question about opening file of underlying filesyste=
m in overlayfs,
 > >  > >  > >
 > >  > >  > > why we use overlayfs' path(vfsmount/dentry) struct for under=
lying fs' file
 > >  > >  > >
 > >  > >  > > in ovl_open_realfile()?  Is it by design?
 > >  > >  >
 > >  > >  > Sure. open_with_fake_path() is only used by overlayfs.
 > >  > >  >
 > >  > >  > IIRC, one of the reasons was to display the user expected path=
 in
 > >  > >  > /proc/<pid>/maps.
 > >  > >  > There may have been other reasons.
 > >  > >  >
 > >  > >
 > >  > > So if we do the mmap with overlayfs'  own page cache, then we don=
't have to
 > >  > > use pseudo path for the reason above, right?
 > >  > >
 > >  > > Actually, the background is I'm trying to implement overlayfs' pa=
ge cache for
 > >  > > fixing mmap rorw issue. The reason why asking this is I need to o=
pen a writeback
 > >  > > file which is used for syncing dirty data from overlayfs' own pag=
e cache to upper inode.
 > >  > > However, if I use the pseudo path just like current opening behav=
ior, the writeback
 > >  > > file will hold a reference of vfsmount of overlayfs and it will c=
ause umount fail with -EBUSY.
 > >  > > So I want to open a writeback file with correct underlying path s=
truct but not sure if
 > >  > > there is any unexpected side effect. Any suggestion?
 > >  >
 > >  > Should be no issue with plain dentry_open() for that purpose.  In f=
act
 > >  > it would be really good to get rid of all that d_real*() mess
 > >  > completely, but that seems some ways off.
 > >  >
 > >  > Did you find the prototype we did with Amir a couple of years back?=
  I
 > >  > can only find bits and pieces in my mailbox...
 > >  >
 > >
 > > I searched in overlayfs mail list but unfortunately didn't  get useful=
 info.
 > > Seems Amir has a git tree for aops prototype but I'm not sure if that =
is the
 > > prototype you mentioned.
 > >
 > > https://github.com/amir73il/linux/commits/ovl-aops-wip
 > >
 > > Hi Amir,
 > >
 > > Do you know the prototype that Miklos mentioned above? Is that the
 > > code in your ovl-aops-wip git tree?
 > >
 >=20
 > Yes it is.
 > The discussion over that branch and remaining TODO is on this thread [1]=
.
 >=20
 > CCing Ritesh who also expressed intention to start beating this
 > branch into shape.
 >=20
 > If you go over the code/emails and still feel lost, I think it is best t=
o have
 > a video call.
 >=20
 > Thanks,
 > Amir.
 >=20
 > [1] https://lore.kernel.org/linux-unionfs/CAJfpegsyA4SjmtAEpkMoKsvgmW0Ci=
EwWEAbU7v3yJztLKmC0Eg@mail.gmail.com/
 >=20

Hi Amir,

Thank you very much, it's very helpful, let me check the mail thread and th=
e content in your branch.

Thanks,
Chengguang





