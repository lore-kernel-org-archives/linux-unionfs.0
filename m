From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: Exporting overlay via NFS?
Date: Wed, 12 Oct 2016 16:29:04 +0200
Message-ID: <20161012142904.GB10902@otheros>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.aperture-lab.de ([138.201.29.205]:49356 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933698AbcJLOpd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Oct 2016 10:45:33 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.aperture-lab.de (Postfix) with ESMTP id 29CBFE09CE
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Oct 2016 16:29:46 +0200 (CEST)
Received: from mail.aperture-lab.de ([127.0.0.1])
        by localhost (mail.aperture-lab.de [127.0.0.1]) (amavisd-new, port 10025)
        with ESMTP id uaEk5_IPncSJ for <linux-unionfs@vger.kernel.org>;
        Wed, 12 Oct 2016 16:29:36 +0200 (CEST)
Received: from localhost (unknown [IPv6:2001:67c:2d50:0:c85:8cff:fe0f:63fe])
        (Authenticated sender: linus.luessing@c0d3.blue)
        by mail.aperture-lab.de (Postfix) with ESMTPSA
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Oct 2016 16:29:36 +0200 (CEST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hi,

I'm currently trying to spice up an NFS share by adding an overlay
fs layer.

As I only found a note regarding issues with using an overlay on
the NFS client side in Documentation/filesystems/overlayfs.txt,
I thought I'd ask about the NFS server side here.


Instead of booting from a /srv/nfs/debian-sid/.amd64,
I want to boot from an overlay like:

/srv/nfs/debian-sid/.amd64 + /srv/nfs/debian-sid/overlay
= /srv/nfs/debian-sid/amd64

This overlay is constructed on the NFS server side.


Without this overlay, things work for me:

/etc/exports:
	/srv/nfs *(ro,async,no_root_squash)

And mounting that with a kernel parameter like:
	... ro root=/dev/nfs net.ifnames=0 ip=:::::eth0:dhcp \
	nfsroot=172.23.208.16:/srv/nfs/debian-sid/.amd64 ...

As well as some more overlay magic in the initrd on the client
side to add a tmpfs over the read-only NFS share. This part works
so far.


Now I'm trying to add an overlayfs on the NFS server side too,
as described above. Unfortunately, this fails on the
nfs-root-booting client side:

~~~
[...]
mount call failed - server replied: Permission denied.
Begin: Retrying nfs mount ... mount call failed - server replied: Permission denied.
done.
Begin: Retrying nfs mount ... mount call failed - server replied: Permission denied.
done.
[...]
~~~


I also tried changing the export from /srv/nfs to
/srv/nfs/debian-sid/amd64, but I still get the permission denied.
The overlay /srv/nfs/debian-sid/amd64 looks fine and with an empty
/srv/nfs/debian-sid/overlay directory identical to the .amd64 one.


NFS server side runs a Debian Jessie with a 4.7.0-0.bpo.1-amd64
kernel. The NFS client side runs a 4.7 kernel, too, and is
supposed to boot a Debian Sid.


Any idea why this permission denied might happen?

Regards, Linus
