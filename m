From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Hi, Is this a problem?
Date: Fri, 23 Sep 2016 10:16:36 +0200
Message-ID: <CAJfpegtQd+zZK0bKmZ5OS4_A4QwGOsdPy8kiduAs2vOL5QWncg@mail.gmail.com>
References: <57E4D443.2040502@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34174 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932454AbcIWIQi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 23 Sep 2016 04:16:38 -0400
Received: by mail-oi0-f41.google.com with SMTP id a62so126608493oib.1
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Sep 2016 01:16:37 -0700 (PDT)
In-Reply-To: <57E4D443.2040502@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Zhang AiHua <zhangaihua1@huawei.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Sep 23, 2016 at 9:05 AM, Zhang AiHua <zhangaihua1@huawei.com> wrote=
:
> mount=EF=BC=9A
> overlay on /tmp type overlay
> (rw,relatime,lowerdir=3D/home/zah/lower,upperdir=3D/home/zah/upper,workdi=
r=3D/home/zah/workdir)
> /dev/mapper/fedora-home on /home type ext4 (rw,relatime,data=3Dordered)
>
> problem as below:
> [root@localhost tmp]# mkdir zzz
> [root@localhost tmp]# chown -R zah zzz
> [root@localhost tmp]# su zah
> mktemp: failed to create file via template =E9=88=A5?tmp/.colorlsXXX=E9=
=88=A5? Permission
> denied
> bash: $TMP: ambiguous redirect
> [zah@localhost tmp]$
> [zah@localhost tmp]$
> [zah@localhost tmp]$
> [zah@localhost tmp]$ ls -alt |grep zzz
> drwxr-xr-x   2 zah  root   4096 Sep 24 02:03 zzz
> [zah@localhost tmp]$ rm -fr zzz
> rm: cannot remove =E9=88=A5=E6=A6=B8zz=E9=88=A5? Permission denied
> [zah@localhost tmp]$
>
> Is this a problem?

Depends on what the permissions are on tmp.

Thanks,
Miklos
