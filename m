Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136C5C433E0
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 03:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2B82217A0
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 03:28:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="shwVLtkd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgGND2x (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 23:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgGND2x (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jul 2020 23:28:53 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD9EC061755
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 20:28:53 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i4so15801226iov.11
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 20:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rv0StJ+iZpJXKHtdbYk54wYgI7cQ7o6joWQgeJkVVWE=;
        b=shwVLtkdkdf5eqK0IsANj6OzXZrb1IUOJQSu59ypOvgd+nf6giPjV0v36oyaH0kmr+
         bMA25wYGDi68cq947Shc7Pjoah2LiWcQSAf6/EFhSMnxNoELdJgq9bzC3qiBUz2LeNdi
         5N2Ee74i+1W2ah+VRaa6L0tAL/n3lKSaFhzAqZCb7nCHj16MOKSTZ67TIPYuMtGalBu/
         EiXgq6NjwR+Fnzvky3V02xmStlA6/F761gJF/QAa3PimhhiewNqrCzJsNqrXjQCrAGCv
         +/PAr1frDO9Qipzvo23wgdmLkt9OvTTJnbdldcazTCWzhrK92eGX6kDyh+J0trkO5gr9
         tdtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rv0StJ+iZpJXKHtdbYk54wYgI7cQ7o6joWQgeJkVVWE=;
        b=V1aTTlConDcrs74o/cTe4APdf/77QRahHmm8rUqoRQ8nStW0v+nWCP/QmK2tqN/zeD
         esZKAKRMVPzHqyJHy3QVv0wEGwyTCQfPEz0ombizdou+HfnooUj2cx7e252icL+bD01m
         492ZJ5YwJ/EiaDoOJXic7dvK9A7LOXTF/+rpDRzwxt7IxHfbpgIi2uh0gzJhlofHJyvF
         NSlWHKt7X8Cwlzsc+yb6UtixUoB8y7i3ggoqE8J3ESstT9XQRDuRIphutC5Qe47RxI+Z
         Fl8vPQovBaY/oQhZCxp3nenLKLLQ4gQh6k6rlUkax6HXr1276YT8s5L8gpoScBcovFOE
         VSEg==
X-Gm-Message-State: AOAM532nA3kZEz1D3jBhCQjNkDqXby3pIvAI11ZNKlP41HI/viJ/EMf0
        aisgr3GWap9C0XHX62GGUpHQXHTc40jvxFHmAJo=
X-Google-Smtp-Source: ABdhPJye7+FvdjKVYnowNyTxmmjFybAj9tywWb1VnoQqcbvblxvnH9PAQ0xmqIkSuCBEv840yVAQ4TtrzeOXIWT/j4o=
X-Received: by 2002:a05:6638:d96:: with SMTP id l22mr3736453jaj.120.1594697332700;
 Mon, 13 Jul 2020 20:28:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200713105732.2886-1-amir73il@gmail.com> <20200713105732.2886-2-amir73il@gmail.com>
 <20200713192517.GA286591@redhat.com>
In-Reply-To: <20200713192517.GA286591@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Jul 2020 06:28:41 +0300
Message-ID: <CAOQ4uxiXWH2RtXdLXRJY-pcZt=zFK-urhcTSQYNbPpmMjFCJdw@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] ovl: invalidate dentry with deleted real dir
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Josh England <jjengla@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 13, 2020 at 10:25 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Mon, Jul 13, 2020 at 01:57:31PM +0300, Amir Goldstein wrote:
> > Changes to underlying layers while overlay in mounted result in
> > undefined behavior.  Therefore, we can change the behavior to
> > invalidate the overlay dentry on dcache lookup if one of the
> > underlying dentries was deleted since the dentry was composed.
> >
> > Negative underlying dentries are not expected in overlay upper and
> > lower dentries.  If they are found it is probably dcache lookup racing
> > with an overlay unlink, before d_drop() was called on the overlay dentry.
> > IS_DEADDIR directories may be caused by underlying rmdir, so invalidate
> > overlay dentry on dcache lookup if we find those.
>
> Can you elaborate a bit more on this race. Doesn't inode_lock_nested(dir)
> protect against that. I see that both vfs_rmdir() and vfs_unlink()
> happen with parent directory inode mutex held exclusively. And IIUC,
> that should mean no further lookup()/->revalidate() must be in progress
> on that dentry? I might very well be wrong, hence asking for more
> details.
>

lookup_fast() looks in dcache without dir inode lock.
d_revalidate() is called to check if the found cached dentry is valid.

For example, ovl_remove_upper() can make an upper dentry negative
or upper dir inode S_DEAD (i.e. vfs_rmdir) just before calling d_drop()
to prevent overlay dentry from being found in fast cache lookup.

Unless I am missing something, that leaves a small window where
lookup_fast() can return an overlay dentry with negative/S_DEAD
upper dentry, which was not caused by illegitimate underlying fs
changes, so we must gracefully invalidate the dcache lookup
(return 0 from revalidate) in order to fallback to fs lookup.

Thanks,
Amir.
