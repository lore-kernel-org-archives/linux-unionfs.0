Return-Path: <SRS0=8cne=AR=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6467C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 16:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E35120708
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 16:10:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="jPcf/DiX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbgGFQKm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 12:10:42 -0400
Received: from mout.gmx.net ([212.227.17.21]:43693 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729293AbgGFQKm (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Jul 2020 12:10:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594051840;
        bh=ab3U4NwNeuwLtzJ5o4CX/0Ae+bzYJRUz8F3rwR/SnKg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=jPcf/DiX5ZNUtdZqVFKZV65BNTohKIo76Qe2ZPRDrbFA5CybKDJgvvqPw/Whu5vQO
         VrZko6M3jQfxScjGQRfz4nEbF/aN+ZPomaqeJPo68tEooV2eIKthpmsrVAwmmpbG7J
         afzCdkGTGn1e1hvsV63TDjQodU6vuZTx75/gOZBM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from fgdesktop.localnet ([91.53.246.204]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mnpnm-1kghsL3nT8-00pLL0; Mon, 06
 Jul 2020 18:10:39 +0200
From:   Fabian <godi.beat@gmx.net>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
Date:   Mon, 06 Jul 2020 18:10:39 +0200
Message-ID: <2480538.KX4unNvOOS@fgdesktop>
In-Reply-To: <CAOQ4uxgGRyrQrLohcENRMakq8tKKdZLVLyTbTN2Ds2KRjW4W0g@mail.gmail.com>
References: <32532923.JtPX5UtSzP@fgdesktop> <106271350.sqX05tTuFB@fgdesktop> <CAOQ4uxgGRyrQrLohcENRMakq8tKKdZLVLyTbTN2Ds2KRjW4W0g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:b4sVF+Br+grTTPZZw4PGQ7S0Vro4/ORuXCi4qBFGh8PQ/fD0QOD
 rMjlB9brnNaos2/6+KLdiVNOPaDBBgsSEj3kub6bkc7TMO8WGlKDGIC+QEl5stdDWa/3bCl
 2Z6MgJDhwDogeQu1B9G0J6d0xlIqOThGk+NXQo157F3jIGwpr67Ykuf+EkxMr27kDxgwpVi
 DaoqMbNVV28CPHaFvJg4w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JjXDvBU62SQ=:KCK+/QUzDwU7vlW4Hr01MT
 tDl0mrndKiwhFkhJ7xgijGHsel1A4qdwruEqA32iT02AoMI+s4VjH06Tbqzj63I2X53D3vvzY
 mUraNfiMK/X73AXYnYJRPmlEvk4gS+gsEsPpRg6Kxe2dUFPoe+cy7KFSxjlFAy/EYy5hSuQg8
 KIPNVbwNDDgLXyOP7cPm3qQ/K7jzFFQ5Wt2uagsXAuld5gWXgxqajg72G5yG/uX0EtbCAucof
 I7kKBPgkrsD07Np5/dHRnzPKQStZx0FZzJM+yqi570Xvme1cQxfQBEFckNRjXFMScgWfwmuzM
 SGhdmNufEMx5oTxILA+A67BMZaBjwPdouivSB5elmBNzyViWLqgacuJlD5AwjqLWjPDBhqQN0
 X8bS08JTlqBpRkbweKkBJyRT9gjgILER6JDspTsWgYBgWa/+MO1WRUwQPpUj0qWkAsIbb/fhq
 gh9HfWG9ToNAPkYf+3YyJ3r60eGKD0nBIUbMRjAL9VvYR/cZBc3oykLH5VLoO1ldoPfk6G8XL
 7Azeyq2G6I6sBAnD0qHlPprAV+Ht1hyYKEWp/bZncIaFdItiDIdep3BZWgKW711XEIvnZZg3N
 6A+RhnLjCAPrKmJ6VMNzXTumXaeher1oXSJHwANVC8EerBRAqr9fB/t05zhR90PdCHzj39lqP
 yLel6Mh+AYguj9LpBGxnYnXfifpditadcR6f+P9cNbrB25GbpAgeA/HbAzoOMk450NEBL1b0Q
 3QzzvWJxlWVraVr6EX5Gwcuq2P2ON8UKEpHN9HdWVrlnocC1HWzet+zp37gqkYi1NK7QvgF+3
 IlBIpqFKXtoXTsWHK2KWyN8tvGOUYWI+RL3BEB5DwYG1ioiG/Ks1WSdLl5lCEP/AG4ZXNzUHp
 TIf8RxhAbdkyq0h08s0ZBEY3+6b3rI68udxxeroTjPEBk0LFiUzFHzg7z4pW4Om2HubPkXzYF
 Uns+y2i2wTStxlxZk0MHUF/kookh55ONJxao2lLsJnLG1pWJYYjuwZRtQLjJ6ibvoV1CBRpWF
 T/TWPQ6xvE0U571ny2hqJQ08pVXL17jAeV96Z/cR6uoIwCaRwHx6gYefX8VzIOJwdol/zwKjr
 XFwih0kFL4DfstU6bd9+i0mAf1ypV6rCkKOMfs2SjSowgEnZ08AuMM0Qk4zPHrfBebKaxiXM2
 oZ47ldiEqyvXvHtxutan1/DrQ/34Mra7YSBfm3TwZ5ZQG/JZjmjBbdS1n16fs9LjztkfjWRhR
 B+OJesG2sIOwi9G5I3SCBbGsRCYiWnHf9Czt4jQ==
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Amir,

Am Montag, 6. Juli 2020, 17:33:54 CEST schrieb Amir Goldstein:
> On Mon, Jul 6, 2020 at 6:14 PM Fabian <godi.beat@gmx.net> wrote:
> > Hi Amir,
> >
> > thanks for your mail and the quick reply!
> >
> > Am Montag, 6. Juli 2020, 16:29:51 CEST schrieb Amir Goldstein:
> > > > We are seeing problems using an read-writeable overlayfs (upper) o=
n a
> > > > readonly squashfs (lower). The squashfs gets an update from time t=
o
> > > > time
> > > > while we keep the upper overlayfs.
> > >
> > > It gets updated while the overlay is offline (not mounted) correct?
> >
> > Yes. We boot into a recovery system outside the rootfs and its overlay=
fs,
> > replace the lower squashfs, and then reboot into the new system.
> >
> > > > On replaced files we then see -ESTALE ("overlayfs: failed to get i=
node
> > > > (-116)") messages if the lower squashfs was created _without_ usin=
g
> > > > the
> > > > "-no-exports" switch.
> > > > The -ESTALE comes from ovl_get_inode() which in turn calls
> > > > ovl_verify_inode() and returns on the line where the upperdentry i=
node
> > > > gets compared
> > > > ( if (upperdentry && ovl_inode_upper(inode) !=3D d_inode(upperdent=
ry))
> > > > ).
> > > >
> > > > A little debugging shows, that the upper files dentry name does no=
t
> > > > fit to
> > > > the dentry name of the new lower dentry as it seems to look for th=
e
> > > > inode
> > > > on the squashfs "export"-lookup-table which has changed as we repl=
aced
> > > > the lower fs.
> > > >
> > > > Building the lower squashfs with the "-no-exports"-mksquashfs opti=
on,
> > > > so
> > > > without the export-lookup-table, seems to work, but it might be no
> > > > longer
> > > > exportable using nfs (which is ok and we can keep with it).
> > > >
> > > > As we didn't find any other information regarding this behaviour o=
r
> > > > anyone
> > > > who also had this problem before we just want to know if this is t=
he
> > > > right way to use the rw overlayfs on a (replaceable) ro squashfs
> > > > filesystem.
> > > >
> > > > Is this a known issue? Is it really needed to disable the export
> > > > feature
> > > > when using overlayfs on a squashfs if we later need to replace
> > > > squashfs
> > > > during an update? Any hints we can have a look on if this should w=
ork
> > > > and
> > > > we might have done wrong during squashfs or overlayfs creation?
> > >
> > > This sounds like an unintentional outcome of:
> > > 9df085f3c9a2 ovl: relax requirement for non null uuid of lower fs
> > >
> > > Which enabled nfs_export for overlay with lower squashfs.
> > >
> > > If you do not need to export overlayfs to NFS, then you can check if=
 the
> > > attached patch solves your problem.
> >
> > With the attached patch i'm now getting to a point where the overlayfs
> > tries to handle the /run-directory (a symlink). There seems to be a
> > -ESTALE at ovl_check_origin_fh() after the for-loop where it checks if
> > origin was not found ( if (!origin) ). Maybe i should debug for more
> > details here? Please let me know.
>
> This is expected. Does it cause any problem?
>
> The patch marks the lower squashfs as "bad_uuid", because:
>         if (!ofs->config.index && uuid_is_null(uuid))
>                 return false;
> ...
>         if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
>                 bad_uuid =3D true;
> ...
>         ofs->fs[ofs->numfs].bad_uuid =3D bad_uuid;
>
> That's ofs->fs[1].bad_uuid =3D bad_uuid;
>
>
> Then in ovl_lookup() =3D> ovl_check_origin() =3D> ovl_check_origin_fh()
> will return ESALE because of:
>                 if (ofs->layers[i].fsid &&
>                     ofs->layers[i].fs->bad_uuid)
>                         continue;
>
> And ovl_check_origin() will return 0 to ovl_lookup().

I'm sorry. You are totaly right! RootFS now completely comes up - just mis=
sed
the console start in our latest inittab - so thought something still hangs=
.
The ESTALE was printed for me because i debugged the whole ESTALE position=
s in
the overlayfs code while studying the first problem. Time to remove my deb=
ug
code...

We will now continue with update tests. If we see something else i will le=
t
you know.


Thanks again for your help and the quick reply!
Fabian


