Return-Path: <SRS0=8cne=AR=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED25BC433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 15:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9FBD20724
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 15:14:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="ambUNZHS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgGFPOZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 11:14:25 -0400
Received: from mout.gmx.net ([212.227.15.19]:55897 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729242AbgGFPOY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Jul 2020 11:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594048461;
        bh=lROcYJbGd3D+D3+fgx5wbkucz8CyHX8jA4xyOo7LZOI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ambUNZHSDDxnVq6Bh/Sq0U8WeJmX943YVqT5nW9DrMQt0yD358/985p5tv61pmB2p
         C/md8iM5RMDQFB/sNBt2usDwAcqsFBIFZhanHCsUprODTwteIUt8oOOFplzo6/1Rtu
         dW1MfNND27i2WqYfE8K2UCPVX+1M+oqj71RwYfGU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from fgdesktop.localnet ([91.53.246.204]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MryT9-1kflY81RHp-00o02R; Mon, 06
 Jul 2020 17:14:21 +0200
From:   Fabian <godi.beat@gmx.net>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
Date:   Mon, 06 Jul 2020 17:14:20 +0200
Message-ID: <106271350.sqX05tTuFB@fgdesktop>
In-Reply-To: <CAOQ4uxjm7i+uO4o4470ACctsft1m18EiUpxBfCeT-Wyqf1FAYg@mail.gmail.com>
References: <32532923.JtPX5UtSzP@fgdesktop> <CAOQ4uxjm7i+uO4o4470ACctsft1m18EiUpxBfCeT-Wyqf1FAYg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:7dh8X1TDX0fCNM4RLOC2k8cWz0beNf0LSpnYSKut0J4yrDNuun4
 Zj1uKpN6KfjoKIxom8fttOAFCfN/NsaiFeVM9eiMm/emoykuWWA2e+qxZnzkv0tzKgQHv1N
 Ahi/112Tn2YoXz+W8FqmWvu8dsaTstaFZx3WCaFOafTQxG0TMYStQgKZoPV2M+e2bpXzS3N
 E1yIiWJhywLDfesPuCDBw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Qj4K1h6LnVM=:7bdeqKDzlYc64hjFWNDBbg
 zxRdzcopBUFXk6OUdqYSMhjAF43ul3VYXAJHZDSBJwXU3ed99L7+XQvBVK5BOkEtSWW6Rs/BL
 RQ+i04jp0KlPLr9WAN7tME9STqRife25gslt1IDW+IminzvraS+7pZbG+kXmRVTfEGoquE9sm
 Kjf6yV6fczQ3UH0rwcX0KWJEMALIxlgzj6hledn06ZTvhXmepyZcVJPr/lT5fZj++eNY7mTeA
 vAi2CttdnX2zzVt//sSOrk6jmwtbWKS0aIExJUcNn5HhWCfepXYgP0fPs7IVkJRIbwCoyPAUH
 /DZTu7Ta8hc4nxcGC1QT1GHDU/8OEaXsveVNJBG8FuI2ASWzEvKMFqqLuMkDPXpoGJAEZKOUw
 CR8UoHGNut07m8Wo3ohfx9SZMEuKco0W3TM8uB6mOv3r2CHDPqpsQcyIEIdgrkwEcUQHn+8ES
 YrXmyqNexweqoPLor4R47kWzaPQ/33T0gh0rbnanWa82OkRyGBN/5PdJbnxRa8iJMIyoHxPZL
 P+mu4ItiFXSVB//6GDk6u08T8J9/64SLmDRDFUFjyU8OKQExgs4jrx+6Y8fq4tdSUldFogbu4
 W+vMbmuEXtCPWp6AsgiQUDHrGqf+Dyv0F0YoQDWlLMRWrIdNdd7SAwzP1KLAZqhQx/SDA/m1K
 XYtlTeVen8tk4RfpU+ZD64X/b4Zwz+pYhiVBJC0sJ0rkE7yHP9SsqluU1sdU9lfDVYJIOApVa
 7j3O7Ayai3UWpUtMpO2vCP7iNNWzejIJeDbh450Jvq687AqsLNY93/xwLzUt53gRpZMy1vu7A
 Iovktu3DAPfB4R8DSiGCoZdLOThsqTYwbD72Jj7WLiGqYml5suCP9A8HkWFLSFwv8EytN+ml5
 GdxYkMZ5P7EmxRnLCrZzyP2zex4SwQnUM9ee0kMV7W7a+asXaTUPqWkciW+0JJ+nOXH+fPYDa
 JnC8Voowazu3z22lded4kua9/Tcs48ZfE5foQA+UMYCbtTsvG4bCRKwT2sVmaw3odl9gvrq1S
 4wSoFE6CW6PClZDFMZtN2Kcf5iZW4Dhze2jkrYvZhMBSw8uXc/DU5SoTBIw5NXBG5NQNlfMkN
 13Nf0L+ONtcRlU/BY3u1CqRQoGSvsWFjiU+PlDBVIgNVPJcql4nFuUvpQZgnuRJjRsVxoVBXC
 RiGlne7oQWtpG4McdYvgh0f473WHweA2EOxnmZYhUSN3U/gdk4m0hXDijVQmECvOaDMXpbSIl
 q1rOKDOj83su2scTw
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Amir,

thanks for your mail and the quick reply!

Am Montag, 6. Juli 2020, 16:29:51 CEST schrieb Amir Goldstein:
> > We are seeing problems using an read-writeable overlayfs (upper) on a
> > readonly squashfs (lower). The squashfs gets an update from time to ti=
me
> > while we keep the upper overlayfs.
>
> It gets updated while the overlay is offline (not mounted) correct?

Yes. We boot into a recovery system outside the rootfs and its overlayfs,
replace the lower squashfs, and then reboot into the new system.

> > On replaced files we then see -ESTALE ("overlayfs: failed to get inode
> > (-116)") messages if the lower squashfs was created _without_ using th=
e
> > "-no-exports" switch.
> > The -ESTALE comes from ovl_get_inode() which in turn calls
> > ovl_verify_inode() and returns on the line where the upperdentry inode
> > gets compared
> > ( if (upperdentry && ovl_inode_upper(inode) !=3D d_inode(upperdentry))=
 ).
> >
> > A little debugging shows, that the upper files dentry name does not fi=
t to
> > the dentry name of the new lower dentry as it seems to look for the in=
ode
> > on the squashfs "export"-lookup-table which has changed as we replaced
> > the lower fs.
> >
> > Building the lower squashfs with the "-no-exports"-mksquashfs option, =
so
> > without the export-lookup-table, seems to work, but it might be no lon=
ger
> > exportable using nfs (which is ok and we can keep with it).
> >
> > As we didn't find any other information regarding this behaviour or an=
yone
> > who also had this problem before we just want to know if this is the
> > right way to use the rw overlayfs on a (replaceable) ro squashfs
> > filesystem.
> >
> > Is this a known issue? Is it really needed to disable the export featu=
re
> > when using overlayfs on a squashfs if we later need to replace squashf=
s
> > during an update? Any hints we can have a look on if this should work =
and
> > we might have done wrong during squashfs or overlayfs creation?
>
> This sounds like an unintentional outcome of:
> 9df085f3c9a2 ovl: relax requirement for non null uuid of lower fs
>
> Which enabled nfs_export for overlay with lower squashfs.
>
> If you do not need to export overlayfs to NFS, then you can check if the
> attached patch solves your problem.

With the attached patch i'm now getting to a point where the overlayfs tri=
es
to handle the /run-directory (a symlink). There seems to be a -ESTALE at
ovl_check_origin_fh() after the for-loop where it checks if origin was not
found ( if (!origin) ). Maybe i should debug for more details here? Please=
 let
me know.

> If you do need to export overlayfs to NFS or to export squashfs to NFS
> for that matter, you will have a problem, because when re-creating
> squashfs (I suppose) all file handles are re-assigned randomly to new
> files, so they have no meaning in the context of NFS file handles export=
ed
> in the old squashfs.

No, i think we currently can live without NFS support. Currently it is mor=
e
important that we can safely replace the lower squashfs.

Thanks again!
Fabian


