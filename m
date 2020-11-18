Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C7DC56202
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Nov 2020 08:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6827241A6
	for <linux-unionfs@archiver.kernel.org>; Wed, 18 Nov 2020 08:27:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sargun.me header.i=@sargun.me header.b="l2yITOMc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgKRI1M (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 18 Nov 2020 03:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgKRI1L (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Nov 2020 03:27:11 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28EEC0613D4
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2020 00:27:11 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id y18so1177784ilp.13
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Nov 2020 00:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6JSsnASGEEmmT+0rR4JRK2MhDJx5jdve6OEXE7gcBvM=;
        b=l2yITOMclwmXPKygoSWHT2HzHx7wmsUB1Dwd9kGhZVxWkbR0z+ZpU5FZUoupcoaxdk
         yz9n7IfBx88to5kg6d3hT+/cMhVD7a+Y/qzyjaw44RI2fG4D4mPJX43oZI1UL87Ypn7k
         DhkG5kBmIMM56nN/HwIsk0YvqP41MLVa4b8xE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6JSsnASGEEmmT+0rR4JRK2MhDJx5jdve6OEXE7gcBvM=;
        b=DRUM5IeRzmWVu/xm7+NEbB6xD69rZsfRq06u/2TY8bVAqdFyb8w29lhugmo3ZI6/4b
         +C+APrHcpUNqU6IBbP0cMrYAcKz9WMVCfp6a8Z+AD/SBjGBoU9O33it7cn045cPZcBpT
         tZbGpf0VEXBR5AHsZkZrogu0PwzzXg5f4uenxZ1W7nUDQTi7fN26b5mJ+maaBVWkExC/
         lESti5cGnACXrQcdzneItwJzsn0onEI3OG5eymZe++zNMON1v0SqdA0oJupv1QkanT7i
         f2asui1teYzYkIvf26sOyJSFHEld/niX7suPDKjFOZOUFFANjVA6EBVrg8UE7Sht4qZ+
         tSmg==
X-Gm-Message-State: AOAM533Yr2pGe3FEBwbe92ukKvbXkqPdaOrfuVgst4/6G4Nu6rvUiMzG
        3QerV7FwmES/qPKb/DiRyQoW0g==
X-Google-Smtp-Source: ABdhPJxkzHDHxJ/cGAtZSv9Ht7V5LrG2NIkvboHpV2xdDYFqa6ZUwTErZWfGxMIgA7s5DcgyE3UERA==
X-Received: by 2002:a92:a805:: with SMTP id o5mr16194779ilh.233.1605688031012;
        Wed, 18 Nov 2020 00:27:11 -0800 (PST)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id w81sm15255719ilk.38.2020.11.18.00.27.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Nov 2020 00:27:10 -0800 (PST)
Date:   Wed, 18 Nov 2020 08:27:08 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Chengguang Xu <cgxu519@mykernel.net>
Subject: Re: [RFC PATCH 3/3] overlay: Add the ability to remount volatile
 directories when safe
Message-ID: <20201118082707.GA15687@ircssh-2.c.rugged-nimbus-611.internal>
References: <20201116163615.GA17680@redhat.com>
 <CAOQ4uxgTXHR3J6HueS_TO5La890bCfsWUeMXKgGnvUth26h29Q@mail.gmail.com>
 <20201116210950.GD9190@redhat.com>
 <CAOQ4uxhkRauEM46nbhZuGdJmP8UGQpe+fw_FtXy+S4eaR4uxTA@mail.gmail.com>
 <20201117144857.GA78221@redhat.com>
 <CAOQ4uxg1ZNSid58LLsGC2tJLk_fpJfu13oOzCz5ScEi6y_4Nnw@mail.gmail.com>
 <20201117164600.GC78221@redhat.com>
 <CAOQ4uxgi-8sn4S3pRr0NQC5sjp9fLmVsfno1nSa2ugfM2KQLLQ@mail.gmail.com>
 <20201117182940.GA91497@redhat.com>
 <CAOQ4uxjkmooYY-NAVrSZOU9BDP0azmbrrmkKNKgyQOURR6eqEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjkmooYY-NAVrSZOU9BDP0azmbrrmkKNKgyQOURR6eqEg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Nov 18, 2020 at 09:24:04AM +0200, Amir Goldstein wrote:
> On Tue, Nov 17, 2020 at 8:29 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Tue, Nov 17, 2020 at 08:03:16PM +0200, Amir Goldstein wrote:
> > > > > C. "shutdown" the filesystem if writeback errors happened and return
> > > > >      EIO from any read, like some blockdev filesystems will do in face
> > > > >      of metadata write errors
> > > > >
> > > > > I happen to have a branch ready for that ;-)
> > > > > https://github.com/amir73il/linux/commits/ovl-shutdown
> > > >
> > > >
> > > > This branch seems to implement shutdown ioctl. So it will still need
> > > > glue code to detect writeback failure in upper/ and trigger shutdown
> > > > internally?
> > > >
> > >
> > > Yes.
> > > ovl_get_acess() can check both the administrative ofs->goingdown
> > > command and the upper writeback error condition for volatile ovl
> > > or something like that.
> >
> > This approach will not help mmaped() pages though, if I do.
> >
> > - Store to addr
> > - msync
> > - Load from addr
> >
> > There is a chance that I can still read back old data.
> >
> 
> msync does not go through overlay. It goes directly to upper fs,
> so it will sync pages and return error on volatile overlay as well.
> 
> Maybe there will still be weird corner cases, but the shutdown approach
> should cover most or all of the interesting cases.
When would we check the errseq_t of the upperdir? Only when the user
calls fsync, or upon close? Periodically?

> 
> Thanks,
> Amir.

We can tackle this later, but I suggest the following semantics, which
follow how ext4 works:

https://www.kernel.org/doc/Documentation/filesystems/ext4.txt
errors=remount-ro	Remount the filesystem read-only on an error.
errors=continue		Keep going on a filesystem error.
[Sargun: We probably don't want this one]
errors=panic		Panic and halt the machine if an error occurs.
                        (These mount options override the errors behavior
                        specified in the superblock, which can be configured
                        using tune2fs)

----
We can potentially add a fourth option, which is shutdown -- that would
return something like EIO or ESHUTDOWN for all calls.

In addition to that, we should pass through the right errseqs to make
the errseq helpers work:
int filemap_check_wb_err(struct address_space *mapping, errseq_t since) [1]
errseq_t filemap_sample_wb_err(struct address_space *mapping) [2]
errseq_t file_sample_sb_err(struct file *file)

etc...

These are used by the VFS layer to check for errors after syncfs or for 
interactions with mapped files. 

[1]: https://elixir.bootlin.com/linux/v5.9.7/source/include/linux/fs.h#L2665
[2]: https://elixir.bootlin.com/linux/v5.9.7/source/include/linux/fs.h#L2688
[3]: https://elixir.bootlin.com/linux/v5.9.7/source/include/linux/fs.h#L2700
