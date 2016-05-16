From: Daniel Axtens <dja@axtens.net>
Subject: 45aebeaf4f67 "ovl: Ensure upper filesystem supports d_type" breaking Docker
Date: Mon, 16 May 2016 16:45:09 +1000
Message-ID: <87d1ombix6.fsf@gamma.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35872 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbcEPGpP (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 16 May 2016 02:45:15 -0400
Received: by mail-pa0-f68.google.com with SMTP id xm6so3051737pab.3
        for <linux-unionfs@vger.kernel.org>; Sun, 15 May 2016 23:45:14 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: vgoyal@redhat.com, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, mszeredi@redhat.com, dchinner@redhat.com

Hi,

I installed a fresh 4.6.0 kernel on my ppc64le system, and tried to run
a docker container. It failed.

Docker gave me errors like this:

docker: Error response from daemon: error creating overlay mount to /var/lib/docker/overlay/2bc07cedad2770da2f384d5c1e81a6f45fa3c44a7658f10d02e5973ef76620fc-init/merged: invalid argument.

In dmesg, I'm seeing:

overlayfs: upper fs needs to support d_type.

Reverting 45aebeaf4f67 ("ovl: Ensure upper filesystem supports d_type")
fixes the issue for me. I haven't investigated the root cause yet - at a
guess I'd say either Docker's layering system, or some weird interaction
with namespacing, maybe? I'll have a look when I get a spare moment.

For reference, I'm using docker 1.11.0-dev.

Regards,
Daniel Axtens
