Return-Path: <SRS0=jezc=EP=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE93C2D0A3
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 10:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32BD02065D
	for <linux-unionfs@archiver.kernel.org>; Mon,  9 Nov 2020 10:10:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A6ut3DKD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgKIKK6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 05:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgKIKK5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 9 Nov 2020 05:10:57 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE4EC0613CF
        for <linux-unionfs@vger.kernel.org>; Mon,  9 Nov 2020 02:10:57 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id x20so7751070ilj.8
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Nov 2020 02:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KpssYMdPMbttvMzPJ9Oq5onAZV+3noxT7AIR8yvgNXg=;
        b=A6ut3DKDsAJNt1CVeifJE25H60B3LpINziAHgucLbXb35//tsl6zHuPgmRZ1GGLyWV
         /1rASHYQJWbzCg+kKvw8SMS95c9tAA5K2yWseIOteO2nd2rZHg2k/Q20uYkWo7Hqig6x
         qIUuo1wk1eRyQYwaTYLl4bdoi/n2hdh+C9A2CIaJishELpRhVsi8j/kXIK1iLTfC6Fb2
         lumfmXxpsdj7AcjViuXQVe6qzsnKlI2KaIEM/sGJFZ2Wg01pNY34GTeBx26HEUOafMjR
         9DqRXHvdZ1MmlxWP1mShwZh2KQr1qPYq1yfiUvjOhoplSHz72aS5DxKof4twnL/yLehk
         TOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KpssYMdPMbttvMzPJ9Oq5onAZV+3noxT7AIR8yvgNXg=;
        b=UJ5vAybwmI0EQ3xNExtXdf/lrylTLzMkPo3q+W+r/O2ItNSrUK7gtsAkKW1Rmao8w9
         18743JQkOZ9ZE2303eiRo81aLIfIUy3fvQNhFbv5N/65J5ovoViYnInbOSipyTITqn5p
         OcvrpUCTn+mKBLATA9IGDFlkOp4meiLHFk7DoQlmkk4hK/5skGpXxCSNC7YD5ZBllYWp
         +h4xg0SV0I0f9aKVLDv22VsRMYR+YsKEXR6bNy4pQ3EBE52oPLY3N6oBdzfyKliAVZaA
         RG5U5Z973PKbsW0LF415w80uarVZZ0KWQ25I/P69IGG1q/IHTFow/qTlSsFNQUWww9Zh
         QgxA==
X-Gm-Message-State: AOAM531UfyJ5w8hryeuY1U8zsvEuAXHVkYyPTnDP5v9yZqhRnPHBXcFR
        eS6tUx+e8+AEaTtSf7hv5H3IcsSA+ebzw9s691g=
X-Google-Smtp-Source: ABdhPJy5mZW8THKYHxAdX2F7lGQnCiryivoEtT2BZ3t6V4OucpJfNjHOPfgve3MVJtAkstiDTVInlYzx3nN5SaDy+Ds=
X-Received: by 2002:a92:6403:: with SMTP id y3mr9415271ilb.72.1604916657067;
 Mon, 09 Nov 2020 02:10:57 -0800 (PST)
MIME-Version: 1.0
References: <20200831181529.GA1193654@redhat.com> <CAMp4zn9dF-umZF-LP=f6qWekyupsXTB6B8CeH6km7=9oVYV+NA@mail.gmail.com>
 <20201106190325.GB1445528@redhat.com> <87o8kamfuo.fsf@redhat.com>
 <CAOQ4uxhyzw=fHokRuCDFwD7SUg14_i1W0HMp9AGD6UxC5t5+tQ@mail.gmail.com> <87k0uulxn6.fsf@redhat.com>
In-Reply-To: <87k0uulxn6.fsf@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 9 Nov 2020 12:10:45 +0200
Message-ID: <CAOQ4uxikP==nOGMgTr37OTzkwVgTOrGW49Xd5mDH11O5_OR+wA@mail.gmail.com>
Subject: Re: [PATCH v7] overlayfs: Provide a mount option "volatile" to skip sync
To:     Giuseppe Scrivano <gscrivan@redhat.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, Sargun Dhillon <sargun@sargun.me>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Daniel J Walsh <dwalsh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Nov 9, 2020 at 10:53 AM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>
> > On Fri, Nov 6, 2020 at 9:43 PM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
> >>
> >> Vivek Goyal <vgoyal@redhat.com> writes:
> >>
> >> > On Fri, Nov 06, 2020 at 09:58:39AM -0800, Sargun Dhillon wrote:
> >> >
> >> > [..]
> >> >> There is some slightly confusing behaviour here [I realize this
> >> >> behaviour is as intended]:
> >> >>
> >> >> (root) ~ # mount -t overlay -o
> >> >> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> >> >> none /mnt/foo
> >> >> (root) ~ # umount /mnt/foo
> >> >> (root) ~ # mount -t overlay -o
> >> >> volatile,index=off,lowerdir=/root/lowerdir,upperdir=/root/upperdir,workdir=/root/workdir
> >> >> none /mnt/foo
> >> >> mount: /mnt/foo: wrong fs type, bad option, bad superblock on none,
> >> >> missing codepage or helper program, or other error.
> >> >>
> >> >> From my understanding, the dirty flag should only be a problem if the
> >> >> existing overlayfs is unmounted uncleanly. Docker does
> >> >> this (mount, and re-mounts) during startup time because it writes some
> >> >> files to the overlayfs. I think that we should harden
> >> >> the volatile check slightly, and make it so that within the same boot,
> >> >> it's not a problem, and having to have the user clear
> >> >> the workdir every time is a pain. In addition, the semantics of the
> >> >> volatile patch itself do not appear to be such that they
> >> >> would break mounts during the same boot / mount of upperdir -- as
> >> >> overlayfs does not defer any writes in itself, and it's
> >> >> only that it's short-circuiting writes to the upperdir.
> >> >
> >> > umount does a sync normally and with "volatile" overlayfs skips that
> >> > sync. So a successful unmount does not mean that file got synced
> >> > to backing store. It is possible, after umount, system crashed
> >> > and after reboot, user tried to mount upper which is corrupted
> >> > now and overlay will not detect it.
> >> >
> >> > You seem to be asking for an alternate option where we disable
> >> > fsync() but not syncfs. In that case sync on umount will still
> >> > be done. And that means a successful umount should mean upper
> >> > is fine and it could automatically remove incomapt dir upon
> >> > umount.
> >>
> >> could this be handled in user space?  It should still be possible to do
> >> the equivalent of:
> >>
> >> # sync -f /root/upperdir
> >> # rm -rf /root/workdir/incompat/volatile
> >>
> >
> > FWIW, the sync -f command above is
> > 1. Not needed when re-mounting overlayfs as volatile
> > 2. Not enough when re-mounting overlayfs as non-volatile
> >
> > In the latter case, a full sync (no -f) is required.
>
> Thanks for the clarification.  Why wouldn't a syncfs on the upper
> directory be enough to ensure files are persisted and safe to reuse
> after a crash?
>

My bad. I always confuse sync -f as fsync().

Sorry for the noise,
Amir.
