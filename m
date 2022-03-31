Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA87C433FE
	for <linux-unionfs@archiver.kernel.org>; Thu, 31 Mar 2022 09:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbiCaJ6O (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 05:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbiCaJ51 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Mar 2022 05:57:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2964C6813
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 02:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648720539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UcsV91BvIV3eSb2ZWVjHXw86HK7Qn8dU3LYLvklS51U=;
        b=e2I3FoQGNaL7UkjrOfgu1YxTgbBwi7VRCE9S2vbxOJw2wuvQ291hrK22VKOWXJCVInpTK/
        1i0c2Wb30sk9BJGv/8c6AkcUwmke5QfLQdcoiivZ/s44lsDV7ftd+Eqk1iUsgvsiLJvHGL
        BcyCtdY3C3kZ0MHocHxI2EldmJwf5lg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-kqXi_-TiMve85UBCCaSmBQ-1; Thu, 31 Mar 2022 05:55:34 -0400
X-MC-Unique: kqXi_-TiMve85UBCCaSmBQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACCDD38041C0;
        Thu, 31 Mar 2022 09:55:33 +0000 (UTC)
Received: from localhost (unknown [10.39.192.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BE0140D1B9B;
        Thu, 31 Mar 2022 09:55:32 +0000 (UTC)
From:   Giuseppe Scrivano <gscrivan@redhat.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        linux-unionfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Rodrigo Campos Catelin <rodrigoca@microsoft.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH 00/18] overlay: support idmapped layers
References: <20220329103526.1207086-1-brauner@kernel.org>
        <YkTEWy7byDiPAvzc@redhat.com>
        <20220331084704.l5wkwm6ammcm2fcs@wittgenstein>
Date:   Thu, 31 Mar 2022 11:55:31 +0200
In-Reply-To: <20220331084704.l5wkwm6ammcm2fcs@wittgenstein> (Christian
        Brauner's message of "Thu, 31 Mar 2022 10:47:04 +0200")
Message-ID: <871qyixx7w.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Christian Brauner <brauner@kernel.org> writes:

> On Wed, Mar 30, 2022 at 04:58:03PM -0400, Vivek Goyal wrote:
>> On Tue, Mar 29, 2022 at 12:35:07PM +0200, Christian Brauner wrote:
>> > From: "Christian Brauner (Microsoft)" <brauner@kernel.org>
>> > 
>> > Hey,
>> > 
>> > This adds support for mounting overlay on top of idmapped layers.
>> > 
>> > I have to start by saying a massive thank you to Amir! He did not just
>> > answer my constant overlay questions but also provided quite a few
>> > patches himself in this series in addition to reviews, comments and a
>> > lot of suggestions. Thank you!
>> > 
>> > There have been a lot of requests to unblock this. For just a few select
>> > examples see [3], [4], and [5]. I've worked closely with various
>> > communities among them containerd, Kubernetes, Podman, LXD, runC, crun,
>> > and systemd (For the curious please see the various pull-request and
>> > issues below.) a lot of them already support idmapped mounts since they
>> > are enabled for btrfs, ext4, and xfs (and f2fs and fat fwiw). In
>> > additon, a few colleagues at Microsoft and from Red Hat work on a
>> > Kubernetes Enhancement Proposals (KEP) that also relies on overlayfs
>> > supporting idmapped layers, see [12].
>> > 
>> > Overlayfs on top of idmapped layers will be used in various ways:
>> > 
>> > * Container managers use overlayfs to efficiently share layers between
>> >   containers. However, this only works for privileged containers.
>> >   Layers cannot be shared if both privileged and unprivileged containers
>> >   are used. Layers can also not be shared if non-overlapping idmappings
>> >   are used for unprivileged containers. Layers cannot be shared because
>> >   of the conflicting ownership requirements between the containers.
>> 
>> Hi Christian,
>> 
>> Thank you for this work. This is awesome.
>
> Thanks for saying that! Appreciate it.
>
>> 
>> Wanted to test it. I was wondering how to test it. Some simple
>> instructions will help.
>
> Of course. There are various ways:
>
> 1. Giuseppe has already put up support the containers/storage go library:
>    https://github.com/containers/storage/pull/1180
>    and he's been running workloads with that branch. If you're familiar
>    with that tooling you can just use that.

Vivek, if you vendor the containers/storage branch into Podman you can run something like:

# podman run --uidmap 0:2000:40000 --gidmap 0:8000:50000 --rm fedora sh -c 'grep . /proc/self/?id_map; ls -l /'
/proc/self/gid_map:         0       8000      50000
/proc/self/uid_map:         0       2000      40000
total 16
lrwxrwxrwx.   1 root   root      7 Jul 21  2021 bin -> usr/bin
dr-xr-xr-x.   1 root   root      0 Jul 21  2021 boot
drwxr-xr-x.   5 root   root    340 Mar 31 09:46 dev
drwxr-xr-x.   1 root   root   1682 Mar 31 09:45 etc
drwxr-xr-x.   1 root   root      0 Jul 21  2021 home
lrwxrwxrwx.   1 root   root      7 Jul 21  2021 lib -> usr/lib
lrwxrwxrwx.   1 root   root      9 Jul 21  2021 lib64 -> usr/lib64
drwx------.   1 root   root      0 Feb 21 06:47 lost+found
drwxr-xr-x.   1 root   root      0 Jul 21  2021 media
drwxr-xr-x.   1 root   root      0 Jul 21  2021 mnt
drwxr-xr-x.   1 root   root      0 Jul 21  2021 opt
dr-xr-xr-x. 262 nobody nobody    0 Mar 31 09:46 proc
dr-xr-x---.   1 root   root    206 Mar 31 09:45 root
drwxr-xr-x.   1 root   root     40 Mar 31 09:46 run
lrwxrwxrwx.   1 root   root      8 Jul 21  2021 sbin -> usr/sbin
drwxr-xr-x.   1 root   root      0 Jul 21  2021 srv
dr-xr-xr-x.  12 nobody nobody    0 Mar 31 09:42 sys
drwxrwxrwt.   1 root   root      0 Feb 21 06:47 tmp
drwxr-xr-x.   1 root   root    100 Feb 21 06:47 usr
drwxr-xr-x.   1 root   root    154 Feb 21 06:47 var

you'll notice that it is using idmapped mounts because the container
starts immediately when you change the mappings; without these kernel
patches Podman needs to chown the image first.

Regards,
Giuseppe

