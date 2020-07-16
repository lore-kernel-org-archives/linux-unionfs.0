Return-Path: <SRS0=UrPG=A3=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE54FC433E4
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 13:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A5D720760
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 13:29:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="W6UGGjAZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgGPN3p (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:29:45 -0400
Received: from mout.gmx.net ([212.227.15.15]:56639 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbgGPN3n (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Jul 2020 09:29:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594906181;
        bh=WpRkEA2BRJYQBv1AJF3qEmtvTmDpUe7JXw0Tasz+zrA=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=W6UGGjAZHT8fsM17D7PRHQdXm9Kww/9sqhAWsvuKKSNmdp0mQLIYOf+lqwXKwXo1t
         jp9JdMS5VA16TqRdCBNyjSUK0uV9KQCjj+9oQNgrxYnJ2UIRpqUHSn5vr75IORMezj
         l4yQzPJm6pUJJAa31shAlZlNxyIsYOrB0kQkq4bk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from fgdesktop.localnet ([91.53.245.53]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MuUj2-1knTaZ0lne-00rUnl; Thu, 16
 Jul 2020 15:29:41 +0200
From:   Fabian Godehardt <godi.beat@gmx.net>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
Date:   Thu, 16 Jul 2020 15:29:40 +0200
Message-ID: <3033570.qcJlCFdnYr@fgdesktop>
In-Reply-To: <CAOQ4uxjsfSvTEsy7ikRAco=qJbsAoFPUDr8AcbqFmOndVz-8NQ@mail.gmail.com>
References: <32532923.JtPX5UtSzP@fgdesktop> <2480538.KX4unNvOOS@fgdesktop> <CAOQ4uxjsfSvTEsy7ikRAco=qJbsAoFPUDr8AcbqFmOndVz-8NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:e/FbIc3YWqjY/Ya6PKGMX5ZuDFIIVUeXx4bNeEqAq9GIUX4mFus
 3rIo6UR43idAfqBpgClSOuNm+4ecRU12t4noqD2x4n/dA3sZkm0ZkfQAd6kdZPKi3pFXg5V
 0Sy7PWinYht3c8V9n24cS+GAJ4WJ+wdy9ZM9zmBIBZjqavTX0WH1eNa++S8AbGMm7+TS712
 Q9g75TZYhVUyTZTLFUBew==
X-UI-Out-Filterresults: notjunk:1;V03:K0:uqOKlebe5ZI=:FvDHz0wytlqNBMEddXum7X
 4n+idYpnYLcy+paiWrao80Mqjr8pZnihcBYxXZH67eNVCMvAX3DZ709q7WNhCPMZGPTK9EruA
 kFIY86savxNZKhPZmI5zO9z6yD2vtpZ8L4472cEvVaJv4VxNQwCVxQKb60XguqNcIKSzfkcwR
 UpEJY1ZpwUkSX5dXoLAt1ncz8j06H7GnMfBzziTIBNEM3DwkcvD9zc95liAR1HfQZb+R8F8qx
 It5gaD1Qbzahf5DkEC3m3k4WKTy1ElVFNej77mOj4hb3ATC7XaXpKRPlQ4jdnQ1GTu0yoGK4q
 I8aKfTj00epDGKGMFvMYZ2dHH0sHKnrqWwrgYZvmEXY0YITjKTf5+4EnCOyEyeWdQzZlmr4NJ
 Ublf2wL/aAoYHoQKcCsOTuqmVmsknHWXfbns6RVAuswFDNlSmXCHxkElibjxzg8Z6riZXEgWw
 p3Qtlbm6b2p59S4ru+CTqgJ3ZKA/NJBmAwYD5x56n88uNutln42fzjZ7Ts2yLJiZKsbOZOC/5
 2eAdzZLrCMhyJj0+uptgurvA1SW2qTOusCWGx/dOQaEnSQb2qPFi9GaG7F61bh0GVICNsLofa
 jFo+uupivYm62saqoQ/+YWLu5NvpQ6JVlBPOrEvVfkIKST7+T1VcNYpRi7CbUilc2yPtqH3ON
 PC16BElLZ7Si4p0V9fpu2+BcMoTIvuz+v7gogWS4In7sABbHj65c8ku6bmjZXwZUUvr4XnWQD
 uTcIsj27Q0UWXLGZBiBIXb6S+1PiQJZsJHjg/8K9OBzNzKQxbQMBG9r/OHbRnafdLyS/FBHVd
 4mUzZIN5eklaCTno7nz3iR3EtN+bmJqMuFo54aCv8W5GrpTGkrL1Nqy1ZGTS8GEmGLEpX8BCI
 jm+nsC9M2OvWRWECk2eY2Bgluyo6Hgaf5/CMNEmKb/wnVh+M3cN6A0t5nTrH6onLvB6TRtI9m
 cUm+eZ9gqLP3M3hMcJWPyFcFYSXDUc/jsdnG+AsfzoebQm0+BExOhLXhIIai10s27W+SJkmFe
 vEQ6e8SQ4b32HlDow22ibH1ax/ANC2N8dBnFFnkk62y52mUDHD7FDQNUiBgmpYnvEJWKBNo1+
 UMWo2MPI6h6cU7JQ8qXF/nA1NUvTZtjxiMEcsXIFlnIgMIf9Tn+CD1bLYZ9A+dzu0xLbq2AVh
 /lso/1eB/bYSMLtcqWsDza+adEXxWcKv4YQUrTaXtF+3+VOiAZ4m3dguQi1y91peNyUVbL3f6
 /rtmHZkcvfZ7jpMjslef8bnfC+sYye34aLeNBLw==
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Amir,

Am Montag, 6. Juli 2020, 19:14:11 CEST schrieb Amir Goldstein:
> On Mon, Jul 6, 2020 at 7:10 PM Fabian <godi.beat@gmx.net> wrote:
> > Hi Amir,
> >
> > Am Montag, 6. Juli 2020, 17:33:54 CEST schrieb Amir Goldstein:
> > > On Mon, Jul 6, 2020 at 6:14 PM Fabian <godi.beat@gmx.net> wrote:
> > > > Hi Amir,
> > > >
> > > > thanks for your mail and the quick reply!
> > > >
> > > > Am Montag, 6. Juli 2020, 16:29:51 CEST schrieb Amir Goldstein:
> > > > > > We are seeing problems using an read-writeable overlayfs (uppe=
r)
> > > > > > on a
> > > > > > readonly squashfs (lower). The squashfs gets an update from ti=
me
> > > > > > to
> > > > > > time
> > > > > > while we keep the upper overlayfs.
> > > > >
> > > > > It gets updated while the overlay is offline (not mounted) corre=
ct?
> > > >
> > > > Yes. We boot into a recovery system outside the rootfs and its
> > > > overlayfs,
> > > > replace the lower squashfs, and then reboot into the new system.
> > > >
> > > > > > On replaced files we then see -ESTALE ("overlayfs: failed to g=
et
> > > > > > inode
> > > > > > (-116)") messages if the lower squashfs was created _without_
> > > > > > using
> > > > > > the
> > > > > > "-no-exports" switch.
> > > > > > The -ESTALE comes from ovl_get_inode() which in turn calls
> > > > > > ovl_verify_inode() and returns on the line where the upperdent=
ry
> > > > > > inode
> > > > > > gets compared
> > > > > > ( if (upperdentry && ovl_inode_upper(inode) !=3D
> > > > > > d_inode(upperdentry))
> > > > > > ).
> > > > > >
> > > > > > A little debugging shows, that the upper files dentry name doe=
s
> > > > > > not
> > > > > > fit to
> > > > > > the dentry name of the new lower dentry as it seems to look fo=
r
> > > > > > the
> > > > > > inode
> > > > > > on the squashfs "export"-lookup-table which has changed as we
> > > > > > replaced
> > > > > > the lower fs.
> > > > > >
> > > > > > Building the lower squashfs with the "-no-exports"-mksquashfs
> > > > > > option,
> > > > > > so
> > > > > > without the export-lookup-table, seems to work, but it might b=
e no
> > > > > > longer
> > > > > > exportable using nfs (which is ok and we can keep with it).
> > > > > >
> > > > > > As we didn't find any other information regarding this behavio=
ur
> > > > > > or
> > > > > > anyone
> > > > > > who also had this problem before we just want to know if this =
is
> > > > > > the
> > > > > > right way to use the rw overlayfs on a (replaceable) ro squash=
fs
> > > > > > filesystem.
> > > > > >
> > > > > > Is this a known issue? Is it really needed to disable the expo=
rt
> > > > > > feature
> > > > > > when using overlayfs on a squashfs if we later need to replace
> > > > > > squashfs
> > > > > > during an update? Any hints we can have a look on if this shou=
ld
> > > > > > work
> > > > > > and
> > > > > > we might have done wrong during squashfs or overlayfs creation=
?
> > > > >
> > > > > This sounds like an unintentional outcome of:
> > > > > 9df085f3c9a2 ovl: relax requirement for non null uuid of lower f=
s
> > > > >
> > > > > Which enabled nfs_export for overlay with lower squashfs.
> > > > >
> > > > > If you do not need to export overlayfs to NFS, then you can chec=
k if
> > > > > the
> > > > > attached patch solves your problem.
> > > >
> > > > With the attached patch i'm now getting to a point where the overl=
ayfs
> > > > tries to handle the /run-directory (a symlink). There seems to be =
a
> > > > -ESTALE at ovl_check_origin_fh() after the for-loop where it check=
s if
> > > > origin was not found ( if (!origin) ). Maybe i should debug for mo=
re
> > > > details here? Please let me know.
> > >
> > > This is expected. Does it cause any problem?
> > >
> > > The patch marks the lower squashfs as "bad_uuid", because:
> > >         if (!ofs->config.index && uuid_is_null(uuid))
> > >
> > >                 return false;
> > >
> > > ...
> > >
> > >         if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
> > >
> > >                 bad_uuid =3D true;
> > >
> > > ...
> > >
> > >         ofs->fs[ofs->numfs].bad_uuid =3D bad_uuid;
> > >
> > > That's ofs->fs[1].bad_uuid =3D bad_uuid;
> > >
> > >
> > > Then in ovl_lookup() =3D> ovl_check_origin() =3D> ovl_check_origin_f=
h()
> > >
> > > will return ESALE because of:
> > >                 if (ofs->layers[i].fsid &&
> > >
> > >                     ofs->layers[i].fs->bad_uuid)
> > >
> > >                         continue;
> > >
> > > And ovl_check_origin() will return 0 to ovl_lookup().
> >
> > I'm sorry. You are totaly right! RootFS now completely comes up - just
> > missed the console start in our latest inittab - so thought something
> > still hangs. The ESTALE was printed for me because i debugged the whol=
e
> > ESTALE positions in the overlayfs code while studying the first proble=
m.
> > Time to remove my debug code...
> >
> > We will now continue with update tests. If we see something else i wil=
l
> > let
> > you know.
>
> OK. please report back when done testing so I can add your tested-by

A lot of tests are done without any problems so far. From our point of vie=
w
the patch works very well.


Thanks again!
Fabian


