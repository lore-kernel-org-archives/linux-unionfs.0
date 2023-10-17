Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D28ECDB474
	for <linux-unionfs@archiver.kernel.org>; Tue, 17 Oct 2023 10:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbjJQKMV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 06:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343644AbjJQKMO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2023 06:12:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886C1B0
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2023 03:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697537485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rwd7Uerr4QawAXyRWr+gHx3qqJAjVyvT+xSoMkxVtuY=;
        b=Lh0/0uMXAgFiJ0ysH62l5+Omz3TT9CH0D7mLnv2ISMnP4EcABF2U2CRC1SS594X/I6ovg5
        tciSYwqWToPcWEaJZKDxy7Z+XC0/Zcu33VTi/VzKh07FhkfrYGPadYcPwk3PQN978ehhSd
        xSOu7rZjR+JrHhbXtY7aSf3NYYAnqRA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-tubGCGQ5MWK9xFL0HhM4Yw-1; Tue, 17 Oct 2023 06:11:22 -0400
X-MC-Unique: tubGCGQ5MWK9xFL0HhM4Yw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B168A2999B34;
        Tue, 17 Oct 2023 10:11:21 +0000 (UTC)
Received: from ws.net.home (unknown [10.45.226.1])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0060A40C6CA0;
        Tue, 17 Oct 2023 10:11:20 +0000 (UTC)
Date:   Tue, 17 Oct 2023 12:11:18 +0200
From:   Karel Zak <kzak@redhat.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
Message-ID: <20231017101118.5h7pj26vos32h63u@ws.net.home>
References: <CAJfpegsexQsNVMOZw+0byzj2wTbU_Tg6p0ATgwBAwmTaDmNbLA@mail.gmail.com>
 <CAOQ4uxjYGckJA=raAW8wyVmDaK-FXfFDRS0RCpZYcLucPqMi3w@mail.gmail.com>
 <CAJfpegt5COamxm-ZN+A9ub_Te-CPM0xMd-Rrzwv7OHBkvHS3yg@mail.gmail.com>
 <CAOQ4uxic3NDtEt9EiP+RYKGEB=6b_PCaudQA=cXK6mWY4Cmeqg@mail.gmail.com>
 <CAJfpegsr3A4YgF2YBevWa6n3=AcP7hNndG6EPMu3ncvV-AM71A@mail.gmail.com>
 <CAJfpegt7VC94KkRtb1dfHG8+4OzwPBLYqhtc8=QFUxpFJE+=RQ@mail.gmail.com>
 <CAOQ4uxhg+0_S1tQv9vUpv7Yu-VRLv7U7cnxLmxig+9LmS_qW+A@mail.gmail.com>
 <CAJfpegu6cESPijvO51zjVeXA=wcw7nMaNkkNJ7+my07wq8k9FA@mail.gmail.com>
 <CAOQ4uxicurA4nNeDkUarkTMujtsaOvwQ8HEMpz97N2SejBRx9Q@mail.gmail.com>
 <CAJfpegv=UXqYQzvH6+py76MV7+5L6=3a+_J7LpHQ0VK5YYrAUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJfpegv=UXqYQzvH6+py76MV7+5L6=3a+_J7LpHQ0VK5YYrAUA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Oct 16, 2023 at 03:10:33PM +0200, Miklos Szeredi wrote:
> On Mon, 16 Oct 2023 at 13:56, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Mon, Oct 16, 2023 at 12:27 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Sun, 15 Oct 2023 at 08:58, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > > +       for (nr = 0; nr < nr_added_lower; nr++, lowerdirs++) {
> > > > +               if (nr < nr_merged_lower)
> > > > +                       seq_show_option(m, "lowerdir+", *lowerdirs);
> > > > +               else
> > > > +                       seq_show_option(m, "datadir+", *lowerdirs);
> > >
> > > Good.
> > >
> > > I did some testing and it turns out libmount still regresses on
> > > 6.6-rc6 for the escaped comma case.  The reason is that libmount
> > > doesn't understand escaping of commas, hence the '-oupper=upper\,1'
> > > will result in two fsconfig() calls: 'upper=upper\'  and '1'.  Prior
> > > to 6.5 these were nicely reconstructed into the original
> > > 'upper=upper\,1' by  legacy_parse_param().

Yes, libmount does not interpret '\,' in any way, it's just comma
after a char :-)

> >
> > Technically, I think this is a libmount regression, not a kernel regression.
> > Since libmount 2.39, libmount will split the commas differently than
> > overlayfs always did.

The difference is that old libmount versions do not split the string;
it only removes well-known non-kernel stuff and flags from the string.
However, the rest of the string remains unmodified. This means that
"upper=aaa,bbb" comprises two options for the old libmount, but
because it neither reorders nor splits it, it is sent unmodified to
the mount(2) syscall.

The new libmount works with mount options differently. It keeps them
parsed in memory (in a struct libmnt_optlist), and this list is used
for fsconfig().

> Ah, but it's not a regression after all, since the kernel un-split the
> same commas until 6.5, so there was no way the libmount devs would
> have observed any regression in overlayfs mount.   But arguing about
> which component is the cause of the regression is not very productive.
> Indeed libmount can be fixed parse overlayfs options the same way as
> the kernel parsed them before 6.5, which is probably a much better
> fix, than a kernel one.
> 
> Karel, is doing such filesystem specific option handling feasible?

For decade we have support for commas in mount option due to
creativity of SELinux developers:

    foo,context="aaa,bbb,ccc",bar

is valid mount options string and libmount will ignore commas within
" " and split it to foo, bar, and context=.

The current util-linux git (and old 6.2 kernel):

# strace -e fsopen,fsconfig ./mount -t overlay overlay -o 'lowerdir="/tmp/test-lower,",upperdir=/tmp/test-upper,workdir=/tmp/test-work' /tmp/test 
fsopen("overlay", FSOPEN_CLOEXEC)       = 3
fsconfig(3, FSCONFIG_SET_STRING, "source", "overlay", 0) = 0
fsconfig(3, FSCONFIG_SET_STRING, "lowerdir", "/tmp/test-lower,", 0) = -1 EINVAL (Invalid argument)

You can see "/tmp/test-lower,".

Maybe all we need is to improve mount(8) docs to force people use ""
for paths when used in mount options.

Anyway, I think we can improve libmount to ignore \, as non-separator.
The question is what the rest of the userspace universe, because fstab
is interpreted on many places ...

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

