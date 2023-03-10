Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E87BC6FA99
	for <linux-unionfs@archiver.kernel.org>; Fri, 10 Mar 2023 11:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjCJLXf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 10 Mar 2023 06:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjCJLXf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Mar 2023 06:23:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243156EB97
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Mar 2023 03:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678447366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dN7k3B6BEud1duRFuYX92Z8qXcuxs3rcZhY8CwxCvGc=;
        b=N7TDJPvocdeeVRb4T2bVEFCs4rvPMZmqu/mZ1TXvX37UqXKgi7HFBb2YuL/ut2+ZUI9KeN
        2uIt2iKR4qXQ+ch1y6/rE4iGnFuLXbLwEJUcXjMg2KstfK1m37RjTTVnnkMQCArF5aC7kJ
        V4mntj1bkJgP9sZHgWHlnNFxMorcbJM=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-5dLMjYaRP8aCmttnY5ogXw-1; Fri, 10 Mar 2023 06:22:45 -0500
X-MC-Unique: 5dLMjYaRP8aCmttnY5ogXw-1
Received: by mail-il1-f198.google.com with SMTP id z8-20020a92cd08000000b00317b27a795aso2472573iln.0
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Mar 2023 03:22:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678447364;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dN7k3B6BEud1duRFuYX92Z8qXcuxs3rcZhY8CwxCvGc=;
        b=T/yWHOy4vh2xDQlVV4M9TEjsfiMiEuWhz8l5Gn8HKB1HC2VcD+dBGF/rcSWX3J4oqs
         Yx7WYdyccpghGJix5+HOBlDA+nz/gorw1HoeZ4XEbvc40AfaTrsnTCRvh9ygMuybQq3X
         hKXon5gb7zyssfg+0cZzBvrXz1QYbp8u0qrbiR54xLolN7bi6/5meBHAsU64GMKo3uu5
         WLIouiE+o4GMR8IlUNpZphW6Fal9cGZfZ6sWJby2W10+YxLB6IZUW0GquFcG54HrJKH0
         fTvwT7gQ1tA0pTlP8wsao6OnzseOKdm4cADvhBEK2yYw5ikJHdB6MiSN2CAhmJYmzw3j
         cNkg==
X-Gm-Message-State: AO0yUKWc24/sFK8JAjkh7ta29XwNEcFGGOBTXiXYxIDBgGhdhTZnYZDh
        g2ZjYNnyRqQUKrtcifadGSDYplm/reGPjAAG4SBRlq7bHnj44lL7xYhYeJQsD10BsTVNXd7Vz+Q
        2ye0nJlW55xs3dUVCB346wSCuc7ozZnkQkNfhPzCWp2qFTlhU9Vvs
X-Received: by 2002:a05:6e02:934:b0:315:9a9a:2cd with SMTP id o20-20020a056e02093400b003159a9a02cdmr12215482ilt.4.1678447364038;
        Fri, 10 Mar 2023 03:22:44 -0800 (PST)
X-Google-Smtp-Source: AK7set+KZ6+bfI5eypR0lIdFPqQXXMOqzThHSfVh9eBO8gh3nF07qpSRuTxfruW3zUArP4zZ4RSKwn5+5hXYmFoH5Jk=
X-Received: by 2002:a05:6e02:934:b0:315:9a9a:2cd with SMTP id
 o20-20020a056e02093400b003159a9a02cdmr12215475ilt.4.1678447363815; Fri, 10
 Mar 2023 03:22:43 -0800 (PST)
MIME-Version: 1.0
References: <CAL7ro1GQcs28kT+_2M5JQZoUN6KHYmA85ouiwjj6JU+1=C-q4g@mail.gmail.com>
In-Reply-To: <CAL7ro1GQcs28kT+_2M5JQZoUN6KHYmA85ouiwjj6JU+1=C-q4g@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Fri, 10 Mar 2023 12:22:32 +0100
Message-ID: <CAL7ro1F9Zu-m4PvHaeGvYAnFE7VaLp=Ykz8zadUWVPX-qjS7dQ@mail.gmail.com>
Subject: Re: WIP: verity support for overlayfs
To:     Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Mar 8, 2023 at 4:28=E2=80=AFPM Alexander Larsson <alexl@redhat.com>=
 wrote:
>
> As was recently discussed in the various threads about composefs we
> want the ability to specify a fs-verity digest for metacopy files,
> such that the lower file used for the data is guaranteed to have the
> specified digest.
>
> I wrote an initial version of this here:
>
>   https://github.com/alexlarsson/linux/tree/overlay-verity

After some discussions with Amir in github I updated the branch. In
this new version there are four verity modes with this behaviour:

Unless you explicitly disable it ("verity=3Doff") all existing xattrs
are validated before use. This is all that happens by default
("verity=3Dvalidate"), but, if you turn on verity ("verity=3Don") then
during metacopy we generate verity xattr in the upper metacopy file (if
the source file has verity enabled). This means later accesses can
guarantee that the correct data is used.

Additionally you can use "verity=3Drequire". In this mode all metacopy
files must have a valid verity xattr. For this to work metadata
copy-up must be able to create a verity xattr (so that later accesses
are validated). Therefore, in this mode, if the lower data file
doesn't have fs-verity enabled we fall back to a full copy rather than
a metacopy.

In addition I changed the code so that validation of lowerdata happens
during lookup. Previously I was trying to do this lazily at use-time,
but that was only done partially right. Amir is doing some general
work on making lookups lazy, so the idea is to migrate the verity
validation to that later.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

