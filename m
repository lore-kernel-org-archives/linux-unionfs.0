Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48986C3E8C5
	for <linux-unionfs@archiver.kernel.org>; Sat, 28 Nov 2020 02:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7F5207CD
	for <linux-unionfs@archiver.kernel.org>; Sat, 28 Nov 2020 02:17:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MBZfPJFd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730301AbgK1CPk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 27 Nov 2020 21:15:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50217 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731493AbgK1CBV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Nov 2020 21:01:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606528872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R4Zi8l3ZKIxJeXLSAM0McyGUGdr5i/PPqj1bQcvcbGk=;
        b=MBZfPJFdg4hUyT3LxdlMjtmUNukJBpsIrpMdKMP5TjrC/n8QJPlPtwk7lyIHTpLlJLm77r
        YB1xlncUi3Mi9hBozHy+7vOvNeFUeUj+4LGVYd8HmBsJPBFWCRunPcyjmaNrf4zrlrlacE
        RILkEE9J9WRnvsXjSe20Ui9WoZpV9pw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-6a9UTadEPfa5N8IGBVW4GQ-1; Fri, 27 Nov 2020 21:01:10 -0500
X-MC-Unique: 6a9UTadEPfa5N8IGBVW4GQ-1
Received: by mail-qk1-f200.google.com with SMTP id r124so4757542qkd.8
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Nov 2020 18:01:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=R4Zi8l3ZKIxJeXLSAM0McyGUGdr5i/PPqj1bQcvcbGk=;
        b=gO9KWwvP8wozSwAL5PIMFToa3TjGs44CUTRsLjXRFX0nW8iK6eX9Y4Zuw9e5gULeTR
         HTFRC64IXueh9Zyj5yvqtrwxEVtKLjrn+Y0jDk11zePuijMOVcIvAVcnk5Ee6moAR3Nq
         D5f5Rx/rQOGvrJpEe+dZ1RJ4DCPpu/WFtlxi+FSgP7H812lWqWyk60FZwTH3m5sLuA5d
         SLQlDsouIGrY/sODtC593YrckvoPAUItESCAVlOwOCdNnT91PwiHpi6m8+cRzrM7VxYd
         u0ETEnPWXCWKfjgTgH2rXch49v7GsRMxawh7g5Onjqzhi3z8Ju9sYM8xq3botAN7Cmf1
         hznQ==
X-Gm-Message-State: AOAM5301uPQ4iGzAYMc4xXfpqdDJAq8DI0zVqP74GJdoWITUWIO2ctpO
        Ncfu0LnwOAsGjCWO/tVAhdxriiDFyl9FnSN5R7s+Syzx8sRY9F4G5FeUEZ33ry97+vE84K9R2M8
        MERAfhYYsfZFoVpqz2yDDUYNs0A==
X-Received: by 2002:a0c:eb91:: with SMTP id x17mr11308170qvo.36.1606528869485;
        Fri, 27 Nov 2020 18:01:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKIQmG/r5SsENO5IxIz0Lu6BYtU25slmJWSehKcRJTMAzc06HGrwLCuYsD1mZENcrHTCLs3Q==
X-Received: by 2002:a0c:eb91:: with SMTP id x17mr11308150qvo.36.1606528869253;
        Fri, 27 Nov 2020 18:01:09 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id n4sm7747503qkf.42.2020.11.27.18.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 18:01:08 -0800 (PST)
Message-ID: <1338a059d03db0e85cf3f3234fd33434a45606c6.camel@redhat.com>
Subject: Re: [PATCH v2 2/4] overlay: Document current outstanding
 shortcoming of volatile
From:   Jeff Layton <jlayton@redhat.com>
To:     Sargun Dhillon <sargun@sargun.me>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date:   Fri, 27 Nov 2020 21:01:07 -0500
In-Reply-To: <20201127221154.GA23383@ircssh-2.c.rugged-nimbus-611.internal>
References: <20201127092058.15117-1-sargun@sargun.me>
         <20201127092058.15117-3-sargun@sargun.me>
         <CAOQ4uxgaLuLb+f6WCMvmKHNTELvcvN8C5_u=t5hhoGT8Op7QuQ@mail.gmail.com>
         <20201127221154.GA23383@ircssh-2.c.rugged-nimbus-611.internal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 2020-11-27 at 22:11 +0000, Sargun Dhillon wrote:
> On Fri, Nov 27, 2020 at 02:52:52PM +0200, Amir Goldstein wrote:
> > On Fri, Nov 27, 2020 at 11:21 AM Sargun Dhillon <sargun@sargun.me> wrote:
> > > 
> > > This documents behaviour that was discussed in a thread about the volatile
> > > feature. Specifically, how failures can go hidden from asynchronous writes
> > > (such as from mmap, or writes that are not immediately flushed to the
> > > filesystem). Although we pass through calls like msync, fallocate, and
> > > write, and will still return errors on those, it doesn't guarantee all
> > > kinds of errors will happen at those times, and thus may hide errors.
> > > 
> > > In the future, we can add error checking to all interactions with the
> > > upperdir, and pass through errseq_t from the upperdir on mappings,
> > > and other interactions with the filesystem[1].
> > > 
> > > [1]: https://lore.kernel.org/linux-unionfs/20201116045758.21774-1-sargun@sargun.me/T/#m7d501f375e031056efad626e471a1392dd3aad33
> > > 
> > > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > > Cc: linux-fsdevel@vger.kernel.org
> > > Cc: linux-unionfs@vger.kernel.org
> > > Cc: Miklos Szeredi <miklos@szeredi.hu>
> > > Cc: Amir Goldstein <amir73il@gmail.com>
> > > Cc: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  Documentation/filesystems/overlayfs.rst | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
> > > index 580ab9a0fe31..c6e30c1bc2f2 100644
> > > --- a/Documentation/filesystems/overlayfs.rst
> > > +++ b/Documentation/filesystems/overlayfs.rst
> > > @@ -570,7 +570,11 @@ Volatile mount
> > >  This is enabled with the "volatile" mount option.  Volatile mounts are not
> > >  guaranteed to survive a crash.  It is strongly recommended that volatile
> > >  mounts are only used if data written to the overlay can be recreated
> > > -without significant effort.
> > > +without significant effort.  In addition to this, the sync family of syscalls
> > > +are not sufficient to determine whether a write failed as sync calls are
> > > +omitted.  For this reason, it is important that the filesystem used by the
> > > +upperdir handles failure in a fashion that's suitable for the user.  For
> > > +example, upon detecting a fault, ext4 can be configured to panic.
> > > 
> > 
> > Reading this now, I think I may have wrongly analysed the issue.
> > Specifically, when I wrote that the very minimum is to document the
> > issue, it was under the assumption that a proper fix is hard.
> > I think I was wrong and that the very minimum is to check for errseq
> > since mount on the fsync and syncfs calls.
> > 
> > Why? first of all because it is very very simple and goes a long way to
> > fix the broken contract with applications, not the contract about durability
> > obviously, but the contract about write+fsync+read expects to find the written
> > data (during the same mount era).
> > 
> > Second, because the sentence you added above is hard for users to understand
> > and out of context. If we properly handle the writeback error in fsync/syncfs,
> > then this sentence becomes irrelevant.
> > The fact that ext4 can lose data if application did not fsync after
> > write is true
> > for volatile as well as non-volatile and it is therefore not relevant
> > in the context
> > of overlayfs documentation at all.
> > 
> > Am I wrong saying that it is very very simple to fix?
> > Would you mind making that fix at the bottom of the patch series, so it can
> > be easily applied to stable kernels?
> > 
> > Thanks,
> > Amir.
> 
> I'm not sure it's so easy. In VFS, there are places where the superblock's 
> errseq is checked[1]. AFAIK, that's going to check "our" errseq, and not the 
> errseq of the real corresponding real file's superblock. One solution might be 
> as part of all these callbacks we set our errseq to the errseq of the filesystem 
> that the upperdir, and then rely on VFS's checking.
> 
> I'm having a hard time figuring out how to deal with the per-mapping based
> error tracking. It seems like this infrastructure was only partially completed
> by Jeff Layton[2]. I don't now how it's actually supposed to work right now,
> as not all of his patches landed.
> 

The patches in the series were all merged, but we ended up going with a
simpler solution [1] than the first series I posted. Instead of plumbing
the errseq_t handling down into sync_fs, we did it in the syscall
wrapper.

I think the tricky part here is that there is no struct file plumbed
into ->sync_fs, so you don't have an errseq_t cursor to work with by the
time that gets called.

What may be easiest is to just propagate the s_wb_err value from the
upper_sb to the overlayfs superblock in ovl_sync_fs(). That should get
called before the errseq_check_and_advance in the syncfs syscall wrapper
and should ensure that syncfs() calls against the overlayfs sb see any
errors that occurred on the upper_sb.

Something like this maybe? Totally untested of course. May also need to
think about how to ensure ordering between racing syncfs calls too
(don't really want the s_wb_err going "backward"):

----------------------------8<---------------------------------
$ git diff
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 290983bcfbb3..d725705abdac 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -283,6 +283,9 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
        ret = sync_filesystem(upper_sb);
        up_read(&upper_sb->s_umount);
 
+       /* Propagate s_wb_err from upper_sb to overlayfs sb */
+       WRITE_ONCE(sb->s_wb_err, READ_ONCE(upper_sb->s_wb_err));
+
        return ret;
 }
----------------------------8<---------------------------------

[1]: https://www.spinics.net/lists/linux-api/msg41276.html

How about I split this into two patchsets? One, where I add the logic to copy
the errseq on callbacks to fsync from the upperdir to the ovl fs superblock,
and thus allowing VFS to bubble up errors, and the documentation. We can CC
stable on those because I think it has an effect that's universal across
all filesystems.

P.S. 
I notice you maintain overlay tests outside of the kernel. Unfortunately, I 
think for this kind of test, it requires in kernel code to artificially bump the 
writeback error count on the upperdir, or it requires the failure injection 
infrastructure. 

Simulating this behaviour is non-trivial without in-kernel support:

P1: Open(f) -> p1.fd
P2: Open(f) -> p2.fd
P1: syncfs(p1.fd) -> errrno
P2: syncfs(p1.fd) -> 0 # This should return an error


[1]: https://elixir.bootlin.com/linux/latest/source/fs/sync.c#L175
[2]: https://lwn.net/Articles/722250/


-- 
Jeff Layton <jlayton@redhat.com>

