Return-Path: <SRS0=8cne=AR=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A84DCC433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 13:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A7B3206F5
	for <linux-unionfs@archiver.kernel.org>; Mon,  6 Jul 2020 13:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="e3UIhJ/e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgGFN1x (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 6 Jul 2020 09:27:53 -0400
Received: from mout.gmx.net ([212.227.15.15]:45893 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728961AbgGFN1x (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 Jul 2020 09:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594042071;
        bh=Wxm7fWBbNzLQzyQ9j7vuzpKJ6kf9GDVmGK7yitnBiZU=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=e3UIhJ/eCOUP/XeJ30FuyHpYSdLdr9r6SUnH3H07p4tpP7B7x+t3zkIiM6uKGZSpE
         iVxxtcoL/qBAEVT0cLM4pAcFvlu7hk8FlPVUKHHhvSp3vcaSN1JllxT3kv+OO8/9G2
         bZjRhXv84B2f7eyBBb5BYhgsEhTRQ90oa644Uk4s=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from fgdesktop.localnet ([91.53.246.204]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mqs4Z-1kegDO30Nt-00mtTe for
 <linux-unionfs@vger.kernel.org>; Mon, 06 Jul 2020 15:27:51 +0200
From:   Fabian <godi.beat@gmx.net>
To:     linux-unionfs@vger.kernel.org
Subject: overlayfs: issue with a replaced lower squashfs with export-table
Date:   Mon, 06 Jul 2020 15:27:51 +0200
Message-ID: <32532923.JtPX5UtSzP@fgdesktop>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:FMKLpNrvQf4QPlNUOQuBNeRirCT9di2NtunOVtErIG+jhd8y4Pw
 XQqrz3sdyryclzGTIz6X+6QxyQN8sDlYMc2mV4uR06CJyodhhmRS9cISi2F77lEHg8GOJgF
 84FYt3tMnlEM1dTqCR/iSwOwgF7jKMmMxrKIxozqE/2PiL0gEovuySnKDVi1a2ihEb6axI8
 gdDTF1H9S5fx0yeCX8Swg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:arVw24lqles=:Em3AEDxMn8w9RUytaSbLdx
 7p6RdXm2hueas7wjZ6rPcGfEl+qae7c9jBxZpL4WllOIVflETQOTvoLvRrrqathFGqnldkHEX
 kdGsnpjbN6f9hEaZgnTfa/5+jFD7mGoNSCCjEAjP0g0ukLGVjQMD4g4iNIfNAlXV3xtltgLwB
 bCfbvBjdRI/HNriTcD9u3U997vQgdIQO6tOrdDGVj327C4eNJMjbLqCmIQcfEewI4u6Xuyozt
 Dy9owuseyRK6/tLPqbqZSG6vvlR8sZSEYcCIEa0TBeMaD8941P9/U+mnU9s9xrEndQJDRLyzg
 +NmB47RKzm0HgPSUIkG2CqbOPmvXbkzK4KXCmmqtyyPGREyUl1aSYBnJM9LJ9uEwH6I45xPIQ
 jKfCItk+jwdakUi5QmKAWPyKRaOdWdVAYHIeyrxQlMbY6EIwEVEjc6kKvmNw15CmS01MytaRq
 u9zlmAqw9evEIrx75bHX68fSsCSDzzZOYX7ZbAW+juJCp8hiaPj9W/BljMTf0e3Kk/0RfnB4X
 nlJIqlMb9nfTe96wVtmJi3evf3oR7g39bE6DdI4w1zscONMyOBkpAlRXWW7NIHI7gnf7yVadC
 Emj+OIguWgqm6AFt/fC9mSMFrXZTiU0QZZbwicKDayeqXvyUcozA7b1eCeOrm5wpXSi2PuqfT
 iLDBumxq3tXx5H0RW8miT7g/4NpcT8SggEK/MdTRRvb1R0FBT6caUhUd2L6zS2sXZZIPcBGNC
 mLpbSn9lRJz62+wyYgAybz59NckeMBLFG3RVoKXyg602dQtsIpKK6FfZ5p3M3msOBEFikSezm
 lTtA2S12Y97R+2Bsb8qfhm3hzyYJK1h0fa1fCtZwLkvVj4zidUREHIRdnbl9jF4iWHQmQsnLr
 gvccT1JY8v14tHiUlXtVBYiWf8Fjj7brLv5HNIWnWgZJ+HqpPsyVhg3ixvEPcSFeNVhTDo74L
 YcKUkLOq2StHaTTNQvntUh9cAI2Dx7HLKa27GFef6YKz5Et4Yh8/nFp9JLxou96yyzHvedbba
 2IVXebtf2+5u1BaM66b26nNC3hC5RYQ3Z3PXEHslVr1wvSRD56EABbPRnWTx5favXjnTpcsRP
 lkHwweZJl7p3rR2ya173Th1o4PghIv/hvVrhEFyvzrWi5yDvbCdI6mMSqXgnq5hHPwo/Lwk+x
 YaWHp4DDDPF9KfAFuhDOkWKf3/NCEPQdcOBg30nPXeiQyqliDzUtXgGi2/9pTXrAUXlWTZUV1
 8JKCqZRjeSWXbA3uoXCpMnnu4rSGJVYhw8w880A==
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hope this is the right list for asking overlayfs <-> squashfs related issu=
es.
Else please let me know where to ask.

We are seeing problems using an read-writeable overlayfs (upper) on a read=
only
squashfs (lower). The squashfs gets an update from time to time while we k=
eep
the upper overlayfs.

On replaced files we then see -ESTALE ("overlayfs: failed to get inode (-1=
16)")
messages if the lower squashfs was created _without_ using the "-no-export=
s"
switch.
The -ESTALE comes from ovl_get_inode() which in turn calls ovl_verify_inod=
e()
and returns on the line where the upperdentry inode gets compared
( if (upperdentry && ovl_inode_upper(inode) !=3D d_inode(upperdentry)) ).

A little debugging shows, that the upper files dentry name does not fit to=
 the
dentry name of the new lower dentry as it seems to look for the inode on t=
he
squashfs "export"-lookup-table which has changed as we replaced the lower =
fs.

Building the lower squashfs with the "-no-exports"-mksquashfs option, so
without the export-lookup-table, seems to work, but it might be no longer
exportable using nfs (which is ok and we can keep with it).

As we didn't find any other information regarding this behaviour or anyone=
 who
also had this problem before we just want to know if this is the right way=
 to
use the rw overlayfs on a (replaceable) ro squashfs filesystem.

Is this a known issue? Is it really needed to disable the export feature w=
hen
using overlayfs on a squashfs if we later need to replace squashfs during =
an
update? Any hints we can have a look on if this should work and we might h=
ave
done wrong during squashfs or overlayfs creation?

Thanks in advance for any hints!

Fabian


