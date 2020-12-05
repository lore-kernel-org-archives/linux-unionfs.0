Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94DDAC433FE
	for <linux-unionfs@archiver.kernel.org>; Sat,  5 Dec 2020 18:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66E522332A
	for <linux-unionfs@archiver.kernel.org>; Sat,  5 Dec 2020 18:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725274AbgLESVu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 5 Dec 2020 13:21:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725270AbgLESVd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 5 Dec 2020 13:21:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607192405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eJ3TlJLyB/D1p6iBoOSpxo7AX6033ynhX3Zy+9CpELA=;
        b=YVOSnSWGW0QRVfWEZg63Rglk6zYGeU23hWFIWvOlKju/EXWa26PZVk67LjZry7Sdj9+V3B
        uDh5Us2Q370jb5G5QwSS0DdlGOkNNfffhp5AOGCE0xZkSfA4BGtmVRP8Q4QqT27ATqtzOA
        BRDK9ByTB4flEJJc2/VVVQVaN2QbhfY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-P9eh51z_PuG04f4cEBFzFA-1; Sat, 05 Dec 2020 08:51:20 -0500
X-MC-Unique: P9eh51z_PuG04f4cEBFzFA-1
Received: by mail-qv1-f70.google.com with SMTP id f2so7463468qvb.7
        for <linux-unionfs@vger.kernel.org>; Sat, 05 Dec 2020 05:51:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=eJ3TlJLyB/D1p6iBoOSpxo7AX6033ynhX3Zy+9CpELA=;
        b=udUeuyoflyWqOFwNEYrcR3US3rZK+OFBtGIVR4nY84B/rzd0Ysz/SNYC3i5KKGKU1v
         thmVF3GJnyh4Lwuy7UE52jCqZfQkzdoaUCWK0uv/Awm67wODRIPeOInyS4J3RKQFfosk
         tJY0tOXE/YB9yvYxe9duUEujpkQFQ6bFzNDKP6JTLHqe7CsVhhJV2OUzD0X2G2qhAULU
         Twaa4mSCzf2xCDN6ON1Yh7j0ex36Ob7pEHM04U5PWLtaF3immezqJHy98L2oFyCXdAPo
         Jg1UXUtHO3iaBUtr/m88TAYjThx/57hlHiqYbTlkAmSC6aJLqXIaftuy78+umJ/XL3UT
         b+yg==
X-Gm-Message-State: AOAM532tXAHpCHl5KzBhN5GDR8kIh0l94QfU0uLK6FH6Re9OQX1L/kWm
        7D6APsZiBjv+0+XDOqL4LdJAugmMegNecgnCcgCdxakKRs/bwOoxmNzwN/AGfl7MAedWkbw7yiA
        BeN2w5ExkV1dA2ORj2ffmEgfH6g==
X-Received: by 2002:ac8:1486:: with SMTP id l6mr14654702qtj.123.1607176280494;
        Sat, 05 Dec 2020 05:51:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzf0TX7HzWr+7ZlUNgaWDbTFRqjLfGWcFqjWR0uZ/edGk7MUPRmkFxWz347muqImSmgQQ8VbA==
X-Received: by 2002:ac8:1486:: with SMTP id l6mr14654671qtj.123.1607176280168;
        Sat, 05 Dec 2020 05:51:20 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id d11sm8800449qta.64.2020.12.05.05.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Dec 2020 05:51:19 -0800 (PST)
Message-ID: <5468a450ac7e9626af1a61a29ef17a6855d6692f.camel@redhat.com>
Subject: Re: [PATCH v2 4/4] overlay: Add rudimentary checking of writeback
 errseq on volatile remount
From:   Jeff Layton <jlayton@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Sargun Dhillon <sargun@sargun.me>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date:   Sat, 05 Dec 2020 08:51:18 -0500
In-Reply-To: <CAOQ4uxjeG4N7i95D+YFr0zo82nLOjUCdUhD8e1WABFtwtQYzrQ@mail.gmail.com>
References: <20201127092058.15117-1-sargun@sargun.me>
         <20201127092058.15117-5-sargun@sargun.me>
         <20201130191509.GC14328@redhat.com>
         <CAOQ4uxjeG4N7i95D+YFr0zo82nLOjUCdUhD8e1WABFtwtQYzrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 2020-12-05 at 11:13 +0200, Amir Goldstein wrote:
> On Mon, Nov 30, 2020 at 9:15 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > On Fri, Nov 27, 2020 at 01:20:58AM -0800, Sargun Dhillon wrote:
> > > Volatile remounts validate the following at the moment:
> > >  * Has the module been reloaded / the system rebooted
> > >  * Has the workdir been remounted
> > > 
> > > This adds a new check for errors detected via the superblock's
> > > errseq_t. At mount time, the errseq_t is snapshotted to disk,
> > > and upon remount it's re-verified. This allows for kernel-level
> > > detection of errors without forcing userspace to perform a
> > > sync and allows for the hidden detection of writeback errors.
> > > 
> > > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > > Cc: linux-fsdevel@vger.kernel.org
> > > Cc: linux-unionfs@vger.kernel.org
> > > Cc: Miklos Szeredi <miklos@szeredi.hu>
> > > Cc: Amir Goldstein <amir73il@gmail.com>
> > > Cc: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  fs/overlayfs/overlayfs.h | 1 +
> > >  fs/overlayfs/readdir.c   | 6 ++++++
> > >  fs/overlayfs/super.c     | 1 +
> > >  3 files changed, 8 insertions(+)
> > > 
> > > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> > > index de694ee99d7c..e8a711953b64 100644
> > > --- a/fs/overlayfs/overlayfs.h
> > > +++ b/fs/overlayfs/overlayfs.h
> > > @@ -85,6 +85,7 @@ struct ovl_volatile_info {
> > >        */
> > >       uuid_t          ovl_boot_id;    /* Must stay first member */
> > >       u64             s_instance_id;
> > > +     errseq_t        errseq; /* Implemented as a u32 */
> > >  } __packed;
> > > 
> > >  /*
> > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > > index 7b66fbb20261..5795b28bb4cf 100644
> > > --- a/fs/overlayfs/readdir.c
> > > +++ b/fs/overlayfs/readdir.c
> > > @@ -1117,6 +1117,12 @@ static int ovl_verify_volatile_info(struct ovl_fs *ofs,
> > >               return -EINVAL;
> > >       }
> > > 
> > > +     err = errseq_check(&volatiledir->d_sb->s_wb_err, info.errseq);
> > > +     if (err) {
> > > +             pr_debug("Workdir filesystem reports errors: %d\n", err);
> > > +             return -EINVAL;
> > > +     }
> > > +
> > >       return 1;
> > >  }
> > > 
> > > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > > index a8ee3ba4ebbd..2e473f8c75dd 100644
> > > --- a/fs/overlayfs/super.c
> > > +++ b/fs/overlayfs/super.c
> > > @@ -1248,6 +1248,7 @@ static int ovl_set_volatile_info(struct ovl_fs *ofs, struct dentry *volatiledir)
> > >       int err;
> > >       struct ovl_volatile_info info = {
> > >               .s_instance_id = volatiledir->d_sb->s_instance_id,
> > > +             .errseq = errseq_sample(&volatiledir->d_sb->s_wb_err),
> > 
> > errse_sample() seems to return 0 if nobody has seen the error yet. That
> > means on remount we will fail. It is a false failure from our perspective
> > and we are not interested in knowing if somebody else has seen the
> > failure or not.
> > 
> > Maybe we need a flag in errseq_sample() to get us current value
> > irrespective of the fact whether anybody has seen the error or not?
> > 
> > If we end up making this change, then we probably will have to somehow
> > mask ERRSEQ_SEEN bit in errseq_check() comparison. Because if we
> > sampled ->s_wb_err when nobody saw it and later by the remount time
> > say ERRSEQ_SEEN is set, we don't want remount to fail.
> > 
> 
> Hopping back to this review, looks like for volatile mount we need
> something like (in this order):
> 1. check if re-use and get sampled errseq from volatiledir xattr
> 2. otherwise errseq_sample() upper_sb and store in volatiledir xattr

I'm not sure I follow. Why does this need to go into an xattr?

errseq_t is never persisted on stable storage. It's an entirely
in-memory thing.


> 3. errseq_check() since stored or sampled errseq (0 for fresh mount
> with unseen error)
> 4. fail volatile mount if errseq_check() failed
> 5. errseq_check() since stored errseq on fsync()/syncfs()
> 

I think this is simpler than that. You just need a new errseq_t helper
that only conditionally samples if the thing is 0 or if the error has
already been seen. Something like this (hopefully with a better name):

bool errseq_sample_no_unseen(errseq_t *eseq, errseq_t *sample)         
{                                                                      
        errseq_t old = READ_ONCE(*eseq);                               
                                                                       
        if (old && !(old & ERRSEQ_SEEN))                               
                return false;                                          
        *sample = old;                                                 
        return true;                                                   
}                                                                      
       
If that returns false, fail the mount. If it's true, then save off the
sample and proceed.

> For fresh volatile mount, syncfs can fix the temporary mount error.
> For re-used volatile mount, the mount error is permanent.
> 
> Did I miss anything?
> Is the mount safe for both seen and unseen error cases? no error case?
> Are we safe if a syncfs on upper_sb sneaks in between 2 and 3?
> 
> Thanks,
> Amir.
> 

-- 
Jeff Layton <jlayton@redhat.com>

