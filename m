Return-Path: <SRS0=N6pz=6A=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA4DC2BA2B
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 06:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29AFE20732
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Apr 2020 06:31:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="XE4ykFX6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407967AbgDPGbO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Apr 2020 02:31:14 -0400
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25352 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408138AbgDPGbJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Apr 2020 02:31:09 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1587018615; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=BohS/ttidY5gwbQUBMYj7bid5YcYdw9K75LvVwg8O2qM+WX6r7kCaFTMzjzGWdFJVZee75MX1lvOPUOXo0klCoQ1nSC/oTll8Na6DdVWHYMAIduVS8mbab4alHQWQwR5J1SMm4MPkazQmBdjKQ0JY02D8+hJqzS9KKK73Ek7W5E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1587018615; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=3wZvJXs7b5jKMWes5Mgv3w7T2fjWpYaRQdYmURsS7/M=; 
        b=MqsTD2ufxz5AO6Ekkde2gqXRjwnHKU/bfFgo74b1PPgO+wmlqeqH6OC9daDqM7KqweA9l4LKHeNuCps2bS64AuzsleNDRRTH9wqi+eFivchlTJRiTDeZ6Yh0bhldmjIn/3t1dt7R35gRWFCHsSpLy/eCSj1S5jeRtnZciCbYRL4=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1587018615;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=3wZvJXs7b5jKMWes5Mgv3w7T2fjWpYaRQdYmURsS7/M=;
        b=XE4ykFX6cHIMDo9QH53ro4TzFDG4maMYTTFyTgOehj4tfhmQDe3E8kQ8p2MfkOfE
        NIEtlgKA/kMrYtHuwDT0to3nX9jz8iKxjvNGfYFwtAk974FtRTgsT4bg7NqMISAcfpe
        pQVHHI8t7Qg6dqrZy3rn0cTulOym/3NlHWPlRF6k=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 158701861456074.09397328565865; Thu, 16 Apr 2020 14:30:14 +0800 (CST)
Date:   Thu, 16 Apr 2020 14:30:14 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <17181ae4719.11b6a2eaa836.5332868079279852281@mykernel.net>
In-Reply-To: <CAOQ4uxgXtjsZXkm60J2omXmnj-2cHwQZ=jmf3+GYN_KdW8JovA@mail.gmail.com>
References: <20200414095310.31491-1-cgxu519@mykernel.net> <CAOQ4uxja_CV5SE57GpS5KyBDudBNn8S9VfT=f_O_qNrwKi8RTg@mail.gmail.com>
 <1717b5c51ab.f6b667969599.7086962587723946588@mykernel.net>
 <CAOQ4uxg+ds5O9gHZs3+sgo08Ut84LPn5MeC=duRqPBtuAOtezw@mail.gmail.com>
 <1717cdb4bcf.11544259d10401.8883493846177492528@mykernel.net>
 <CAOQ4uxg0CYuQ-EfOphk-v-o5hvyVr0UbD5nngse9Zi4M5ZxNgw@mail.gmail.com> <1717cf65ddb.d406587710513.3094673612298718285@mykernel.net> <CAOQ4uxgXtjsZXkm60J2omXmnj-2cHwQZ=jmf3+GYN_KdW8JovA@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: whiteout inode sharing
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

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-04-15 19:26:40 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Wed, Apr 15, 2020 at 11:30 AM Chengguang Xu <cgxu519@mykernel.net> wr=
ote:
 > >
 > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-04-15 16:12:04 Amir =
Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > On Wed, Apr 15, 2020 at 11:01 AM Chengguang Xu <cgxu519@mykernel.ne=
t> wrote:
 > >  > >
 > >  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-04-15 15:03:09 =
Amir Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > >  > On Wed, Apr 15, 2020 at 4:03 AM Chengguang Xu <cgxu519@mykerne=
l.net> wrote:
 > >  > >  > >
 > >  > >  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2020-04-14 21:4=
4:39 Amir Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > >  > >  > >  > On Tue, Apr 14, 2020 at 12:53 PM Chengguang Xu <cgxu519@m=
ykernel.net> wrote:
 > >  > >  > >  > >
 > >  > >  > >  > > Sharing inode with different whiteout files for saving
 > >  > >  > >  > > inode and speeding up deleting operation.
 > >  > >  > >  > >
 > >  > >  > >  > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > >  > >  > >  > > ---
 > >  > >  > >  > > v1->v2:
 > >  > >  > >  > > - Address Amir's comments in v1
 > >  > >  > >  > >
 > >  > >  > >  > > v2->v3:
 > >  > >  > >  > > - Address Amir's comments in v2
 > >  > >  > >  > > - Rebase on Amir's "Overlayfs use index dir as work dir=
" patch set
 > >  > >  > >  > > - Keep at most one whiteout tmpfile in work dir
 > >  > >  > >  > >
 > >  > >  > >  > >  fs/overlayfs/dir.c       | 35 ++++++++++++++++++++++++=
++++-------
 > >  > >  > >  > >  fs/overlayfs/overlayfs.h |  9 +++++++--
 > >  > >  > >  > >  fs/overlayfs/ovl_entry.h |  4 ++++
 > >  > >  > >  > >  fs/overlayfs/readdir.c   |  3 ++-
 > >  > >  > >  > >  fs/overlayfs/super.c     |  9 +++++++++
 > >  > >  > >  > >  fs/overlayfs/util.c      |  3 ++-
 > >  > >  > >  > >  6 files changed, 52 insertions(+), 11 deletions(-)
 > >  > >  > >  > >
 > >  > >  > >  > > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
 > >  > >  > >  > > index 279009dee366..dbe5e54dcb16 100644
 > >  > >  > >  > > --- a/fs/overlayfs/dir.c
 > >  > >  > >  > > +++ b/fs/overlayfs/dir.c
 > >  > >  > >  > > @@ -62,35 +62,55 @@ struct dentry *ovl_lookup_temp(stru=
ct dentry *workdir)
 > >  > >  > >  > >  }
 > >  > >  > >  > >
 > >  > >  > >  > >  /* caller holds i_mutex on workdir */
 > >  > >  > >  > > -static struct dentry *ovl_whiteout(struct dentry *work=
dir)
 > >  > >  > >  > > +static struct dentry *ovl_whiteout(struct ovl_fs *ofs,=
 struct dentry *workdir)
 > >  > >  > >  > >  {
 > >  > >  > >  > >         int err;
 > >  > >  > >  > > +       bool retried =3D false;
 > >  > >  > >  > > +       bool should_link =3D (ofs->whiteout_link_max > =
1);
 > >  > >  > >  > >         struct dentry *whiteout;
 > >  > >  > >  > >         struct inode *wdir =3D workdir->d_inode;
 > >  > >  > >  > >
 > >  > >  > >  > > +retry:
 > >  > >  > >  > >         whiteout =3D ovl_lookup_temp(workdir);
 > >  > >  > >  > >         if (IS_ERR(whiteout))
 > >  > >  > >  > >                 return whiteout;
 > >  > >  > >  > >
 > >  > >  > >  > > +       if (should_link && ofs->whiteout) {
 > >  > >  > >  >
 > >  > >  > >  > What happens with ofs->whiteout_link_max =3D=3D 2 is that=
 half of the
 > >  > >  > >  > times, whiteout gets linked and then unlinked.
 > >  > >  > >  > That is not needed.
 > >  > >  > >  > I think code would look better like this:
 > >  > >  > >  >
 > >  > >  > >  >           if (ovl_whiteout_linkable(ofs)) {
 > >  > >  > >  >                   err =3D ovl_do_link(ofs->whiteout, wdir=
, whiteout);
 > >  > >  > >  > ...
 > >  > >  > >  >           } else if (ofs->whiteout) {
 > >  > >  > >  >                   ovl_cleanup(wdir, ofs->whiteout);
 > >  > >  > >  > ....
 > >  > >  > >  >
 > >  > >  > >  > With:
 > >  > >  > >  >
 > >  > >  > >  > static inline bool ovl_whiteout_linkable(struct ovl_fs *o=
fs)
 > >  > >  > >  > {
 > >  > >  > >  >        return ofs->whiteout &&
 > >  > >  > >  >                  ofs->whiteout->d_inode->i_nlink < ofs->w=
hiteout_link_max;
 > >  > >  > >  > }
 > >  > >  > >  >
 > >  > >  > >
 > >  > >  > > tmpfile has occupied one link, so the maximum link count of =
whiteout inode
 > >  > >  > > in your code will be ofs->whiteout_link_max - 1, right?
 > >  > >  > >
 > >  > >  >
 > >  > >  > Right, but I wrote wrong pseudo code to use this helper.
 > >  > >  > The intention is that ovl_whiteout_linkable(ofs) means there i=
s a tmp whiteout
 > >  > >  > and it may be linked to a new tmp whiteout.
 > >  > >  > The only reason to cleanup tmp whiteout is if link has unexpec=
tedly failed and
 > >  > >  > in this case I think we should disable whiteout sharing.
 > >  > >  >
 > >  > >  > Let me try again:
 > >  > >  >
 > >  > >  > +       err =3D -EMLINK;
 > >  > >  > +       if (ovl_whiteout_linkable(ofs)) {
 > >  > >  > +               err =3D ovl_do_link(ofs->whiteout, wdir, white=
out);
 > >  > >  > +               if (!err)
 > >  > >  > +                       return whiteout;
 > >  > >  > +        }
 > >  > >  > +        if (err && ofs->whiteout) {
 > >  > >  > +               pr_warn("failed to link whiteout - disabling w=
hiteout
 > >  > >  > sharing (nlink=3D%u, err =3D %i)\n",
 > >  > >  > +                             ofs->whiteout->d_inode->i_nlink,=
 err);
 > >  > >  > +               ofs->whiteout_link_max =3D 0;
 > >  > >  > +               should_link =3D false;
 > >  > >  > +               ovl_cleanup(wdir, ofs->whiteout);
 > >  > >  > +               dput(ofs->whiteout);
 > >  > >  > +               ofs->whiteout =3D NULL;
 > >  > >  > +       }
 > >  > >  > +
 > >  > >  >          err =3D ovl_do_whiteout(wdir, whiteout);
 > >  > >  >
 > >  > >  > Is that better?
 > >  > >  >
 > >  > >
 > >  > > I don't fully understand why should we limit to share only one in=
ode for whiteout files.
 > >  > > Consider deleting a lot of files(not dir) in lowerdir, we will ge=
t -EMLINK error because
 > >  > > the link count of shared inode exceeds the maximum link limit in =
underlying file system.
 > >  > > In this case, we can choose another whiteout inode for sharing.
 > >  > >
 > >  >
 > >  > I got it wrong again. I forgot the maxed out case. Take #3:
 > >  >
 > >  > +       err =3D 0;
 > >  > +       if (ovl_whiteout_linkable(ofs)) {
 > >  > +               err =3D ovl_do_link(ofs->whiteout, wdir, whiteout);
 > >  > +               if (!err)
 > >  > +                       return whiteout;
 > >  > +        } else if (ofs->whiteout) {
 > >  > +               dput(whiteout);
 > >  > +               whiteout =3D ofs->whiteout;
 > >  > +               ofs->whiteout =3D NULL;
 > >  > +               return whiteout;
 > >  > +        }
 > >  > +        if (err) {
 > >  > +               pr_warn("failed to link whiteout - disabling whiteo=
ut
 > >  > sharing (nlink=3D%u, err =3D %i)\n",
 > >  > +                             ofs->whiteout->d_inode->i_nlink, err)=
;
 > >  > +               ofs->whiteout_link_max =3D 0;
 > >  > +               should_link =3D false;
 > >  > +               ovl_cleanup(wdir, ofs->whiteout);
 > >  > +       }
 > >  > +
 > >  >          err =3D ovl_do_whiteout(wdir, whiteout);
 > >  >
 > >  >
 > >  > I hope I got the logic right this time.
 > >  > Feel free to organize differently.
 > >  > Disabling should be in the case where failure is not expected
 > >  > so we want to avoid having every whiteout creation try and fail.
 > >  > For example if filesystem reported s_max_links is incorrect.
 > >  >
 > >
 > > In case of any unexpected errors, we could set a error limit(for examp=
le, 10),
 > > if link error count exceeds the limit then we disable the feature.
 > >
 >=20
 > As far as I am concerned, you may post the patch without auto disable,
 > but I object to using an arbitrary number of errors (10) as trigger for =
auto
 > disable.
 >=20
 > I do think that it is important to communicate to admin that the whiteou=
t
 > sharing is not working as expected and it is not acceptable to flood
 > log with warning on each and every whiteout creation, not even with
 > pr_warn_ratelimited.
 >=20
 > There are several ways you can go about this, but here is a suggestion:
 >=20
 > +        if (err) {
 > +               ofs->whiteout_link_max >>=3D 1;
 > +               pr_warn("failed to link whiteout (nlink=3D%u, err =3D %i=
)
 > - lowering whiteout_link_max to %u\n",
 > +                             ofs->whiteout->d_inode->i_nlink, err,
 > ofs->whiteout_link_max);
 > +               should_link =3D false;
 > +               ovl_cleanup(wdir, ofs->whiteout);
 > +       }
 >=20

Frankly speaking, I don't like heuristic method to automatically enable/dis=
able feature,
so I perfer to disable the feature immediately after hitting any error just=
 like your previous suggestion,
and I also hope to add a mount option for this feature to mitigate global e=
ffect to different overlayfs instances.

Thanks,
cgxu




