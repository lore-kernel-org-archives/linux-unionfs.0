Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC00BC64E8A
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Dec 2020 10:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 735CA208FE
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Dec 2020 10:43:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgLCKnK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 05:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgLCKnJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 Dec 2020 05:43:09 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790A2C061A51
        for <linux-unionfs@vger.kernel.org>; Thu,  3 Dec 2020 02:42:29 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id 81so1509585ioc.13
        for <linux-unionfs@vger.kernel.org>; Thu, 03 Dec 2020 02:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=4HKNqxEtrX2erf14xgjR6Ft3QvU5aTFOMd4a93wseJ8=;
        b=hdXeiCHvb8hvJp0QYmDvu94763ydwprKIKMH4IWfFxIuysmDtDuZoj2diP/rmoP9AL
         I5aOiRmu9aBkaq0TVvR75RScL9+YzIqzsXkelI9xvC+TMCGAmYvzfNBSv6D+jqfsLTno
         LNzFnsdcmCcZ6wDGNyNB4eR+Ch1ackLfba+NE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=4HKNqxEtrX2erf14xgjR6Ft3QvU5aTFOMd4a93wseJ8=;
        b=DPPTkxgrBxa+p6jOq6pJu6ql5KLNveO7Gxyxdr2Cl4FyaZArt10fq/dTorBYHzFied
         Ae6+K4N74C1Sa/KB1oyFQLKvq2MWx9lELCW8ukpI96Z5tuQ/V9Uzznp8NcaMtrHyqq5g
         uL7yZCZ24qGfE5MJe8WS+jSLH39CVXWFbU2Pa7Q1cx4Z8x0KTWcHtVPk47O2DsQk+TrY
         ZHD4htOuAT/Fff9MxMpegQotMogiRmuTtHaH+xNzfSTnyHuVhLufTK7xKQtgxy/zPu1g
         pvgbH2gpMZgl1Ec6Mm+tHAB76Qe4QtkVxoanGQVxPP4H7vRkRlCmUNFwUXN3ptKNaZit
         0+AA==
X-Gm-Message-State: AOAM531eLFJJynywr3T+w5G7XMGkfABSYvWH9vqymtrQBlv+TxrOy3ca
        fKQsxDDqYgestr75Nwg0QBajng==
X-Google-Smtp-Source: ABdhPJwKwohMF77/jhTYdL3wghOtlo2O8QCc80R7l+AGHwA2glUJfMAGE9Lk40oFeXp7Z1dY+Rzutg==
X-Received: by 2002:a02:8482:: with SMTP id f2mr2759615jai.93.1606992148439;
        Thu, 03 Dec 2020 02:42:28 -0800 (PST)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id x5sm653161ilm.22.2020.12.03.02.42.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Dec 2020 02:42:27 -0800 (PST)
Date:   Thu, 3 Dec 2020 10:42:26 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] overlay: Implement volatile-specific fsync error
 behaviour
Message-ID: <20201203104225.GA30173@ircssh-2.c.rugged-nimbus-611.internal>
References: <20201202092720.41522-1-sargun@sargun.me>
 <20201202150747.GB147783@redhat.com>
 <f2fc7d688417a1da3d94e819afed6bab404da51f.camel@redhat.com>
 <20201202172906.GE147783@redhat.com>
 <59de2220a85e858a4c397969e2a0d03f1d653a6a.camel@redhat.com>
 <20201202185601.GF147783@redhat.com>
 <0a3979479ffbf080fa1cd492923a7fa8984078b9.camel@redhat.com>
 <20201202213434.GA4070@redhat.com>
 <2e08895bf0650513d7d12e66965eec611f361be3.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e08895bf0650513d7d12e66965eec611f361be3.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Dec 02, 2020 at 04:52:33PM -0500, Jeff Layton wrote:
> On Wed, 2020-12-02 at 16:34 -0500, Vivek Goyal wrote:
> > On Wed, Dec 02, 2020 at 02:26:23PM -0500, Jeff Layton wrote:
> > [..]
> > > > > > > > > +		upper_mnt_sb = ovl_upper_mnt(ofs)->mnt_sb;
> > > > > > > > > +		sb->s_stack_depth = upper_mnt_sb->s_stack_depth;
> > > > > > > > > +		sb->s_time_gran = upper_mnt_sb->s_time_gran;
> > > > > > > > > +		ofs->upper_errseq = errseq_sample(&upper_mnt_sb->s_wb_err);
> > > > > > > > 
> > > > > > > > I asked this question in last email as well. errseq_sample() will return
> > > > > > > > 0 if current error has not been seen yet. That means next time a sync
> > > > > > > > call comes for volatile mount, it will return an error. But that's
> > > > > > > > not what we want. When we mounted a volatile overlay, if there is an
> > > > > > > > existing error (seen/unseen), we don't care. We only care if there
> > > > > > > > is a new error after the volatile mount, right?
> > > > > > > > 
> > > > > > > > I guess we will need another helper similar to errseq_smaple() which
> > > > > > > > just returns existing value of errseq. And then we will have to
> > > > > > > > do something about errseq_check() to not return an error if "since"
> > > > > > > > and "eseq" differ only by "seen" bit.
> > > > > > > > 
> > > > > > > > Otherwise in current form, volatile mount will always return error
> > > > > > > > if upperdir has error and it has not been seen by anybody.
> > > > > > > > 
> > > > > > > > How did you finally end up testing the error case. Want to simualate
> > > > > > > > error aritificially and test it.
> > > > > > > > 
> > > > > > > 
> > > > > > > If you don't want to see errors that occurred before you did the mount,
> > > > > > > then you probably can just resurrect and rename the original version of
> > > > > > > errseq_sample. Something like this, but with a different name:
> > > > > > > 
> > > > > > > +errseq_t errseq_sample(errseq_t *eseq)
> > > > > > > +{
> > > > > > > +       errseq_t old = READ_ONCE(*eseq);
> > > > > > > +       errseq_t new = old;
> > > > > > > +
> > > > > > > +       /*
> > > > > > > +        * For the common case of no errors ever having been set, we can skip
> > > > > > > +        * marking the SEEN bit. Once an error has been set, the value will
> > > > > > > +        * never go back to zero.
> > > > > > > +        */
> > > > > > > +       if (old != 0) {
> > > > > > > +               new |= ERRSEQ_SEEN;
> > > > > > > +               if (old != new)
> > > > > > > +                       cmpxchg(eseq, old, new);
> > > > > > > +       }
> > > > > > > +       return new;
> > > > > > > +}
> > > > > > 
> > > > > > Yes, a helper like this should solve the issue at hand. We are not
> > > > > > interested in previous errors. This also sets the ERRSEQ_SEEN on 
> > > > > > sample and it will also solve the other issue when after sampling
> > > > > > if error gets seen, we don't want errseq_check() to return error.
> > > > > > 
> > > > > > Thinking of some possible names for new function.
> > > > > > 
> > > > > > errseq_sample_seen()
> > > > > > errseq_sample_set_seen()
> > > > > > errseq_sample_consume_unseen()
> > > > > > errseq_sample_current()
> > > > > > 
> > > > > 
> > > > > errseq_sample_consume_unseen() sounds good, though maybe it should be
> > > > > "ignore_unseen"? IDK, naming this stuff is the hardest part.
> > > > > 
> > > > > If you don't want to add a new helper, I think you'd probably also be
> > > > > able to do something like this in fill_super:
> > > > > 
> > > > >     errseq_sample()
> > > > >     errseq_check_and_advance()
> > > > > 
> > > > > 
> > > > > ...and just ignore the error returned by the check and advance. At that
> > > > > point, the cursor should be caught up and any subsequent syncfs call
> > > > > should return 0 until you record another error. It's a little less
> > > > > efficient, but only slightly so.
> > > > 
> > > > This seems even better.
> > > > 
> > > > Thinking little bit more. I am now concerned about setting ERRSEQ_SEEN on
> > > > sample. In our case, that would mean that we consumed an unseen error but
> > > > never reported it back to user space. And then somebody might complain.
> > > > 
> > > > This kind of reminds me posgresql's fsync issues where they did
> > > > writes using one fd and another thread opened another fd and
> > > > did sync and they expected any errors to be reported.
> > > > 
> > > 
> > > > Similary what if an unseen error is present on superblock on upper
> > > > and if we mount volatile overlay and mark the error SEEN, then
> > > > if another process opens a file on upper and did syncfs(), it will
> > > > complain that exisiting error was not reported to it.
> > > > 
> > > > Overlay use case seems to be that we just want to check if an error
> > > > has happened on upper superblock since we sampled it and don't
> > > > want to consume that error as such. Will it make sense to introduce
> > > > two helpers for error sampling and error checking which mask the
> > > > SEEN bit and don't do anything with it. For example, following compile
> > > > tested only patch.
> > > > 
> > > > Now we will not touch SEEN bit at all. And even if SEEN gets set
> > > > since we sampled, errseq_check_mask_seen() will not flag it as
> > > > error.
> > > > 
> > > > Thanks
> > > > Vivek
> > > > 
> > > 
> > > Again, you're not really hiding this from anyone doing something _sane_.
> > > You're only hiding an error from someone who opens the file after an
> > > error occurs and expects to see an error.
> > > 
> > > That was the behavior for fsync before we switched to errseq_t, and we
> > > had to change errseq_sample for applications that relied on that. syncfs
> > > reporting these errors is pretty new however. I don't think we
> > > necessarily need to make the same guarantees there.
> > > 
> > > The solution to all of these problems is to ensure that you open the
> > > files early you're issuing syncfs on and keep them open. Then you'll
> > > always see any subsequent errors.
> > 
> > Ok. I guess we will have to set SEEN bit during error_sample otherwise,
> > we miss errors. I had missed this point.
> > 
> > So mounting a volatile overlay instance will become somewhat
> > equivalent of as if somebody did a syncfs on upper, consumed
> > error and did not do anything about it.
> > 
> > If a user cares about not losing such errors, they need to keep an
> > fd open on upper. 
> > 
> > /me hopes that this does not become an issue for somebody. Even
> > if it does, one workaround can be don't do volatile overlay or
> > don't share overlay upper with other conflicting workload.
> > 
> 
> Yeah, there are limits to what we can do with 32 bits.
> 
> It's not pretty, but I guess you could pr_warn at mount time if you find
> an unseen error. That would at least not completely drop it on the
> floor.
> 
> -- 
> Jeff Layton <jlayton@redhat.com>
> 

If I may enumerate our choices to help my own understanding, and
come up with a decent decision on how to proceed:

1. If the filesystem has an unseen error, pr_warn.
2. If the filesystem has an unseen error, refuse to mount it until
   the user clears the error (via syncfs?).
3. Ignore the beginning state of the upperdir
4. Increment the errseq_t.
5. A combination of #1, and #2 and require the user to mount
   -o reallyvolatile or smoe such.

Now the downsides of each of these options:

1. The user probably won't look at these errors. Especially,
   if the application is a container runtime, and these are
   happening on behalf of the application in an automated fashion.
2. Forcing a syncfs on most filesystems is a massively costly
   operation that we want to avoid with the volatile operation.
   Also, go back to #1. Until we implement the new FS API, we
   can't easily give meaningful warnings to users that they
   can programatically act on (unless we use some special errno).
3. This is a noop.
4. We can hide errors from other users of the upperdir if they
   rely on syncfs semantics rather than per-fd fsync semantics
   to check if the filesystem is "clean".
5. See the issues with #1 and #2.

I'm also curious as to how the patchset that allows for partial
sync is going to deal with this problem [1].

There is one other proposal I have, which is we define errseq_t
as two structures:
-errseq_t errseq_set(errseq_t *eseq, int err);
+/* For use on the publishing-side of errseq */
+struct errseq_publisher {
+        atomic_t        errors;
+        errseq_t        errseq_t
+};
+
+errseq_t errseq_set(struct errseq_publisher *eseq, int err);

And errseq_publisher is on the superblock, and errors is always incremented no 
matter what. We risk wrapping, but I think this falls into Jeff's "sane" test -- 
if there are 2**32+ errors without someone doing an fsync, or noticing, you 
might have other problems.

This has two (and a half) downsides:
1. It is a potential performance concern to introduce an atomic here.
2. It takes more space on the superblock.

1 can be mitigated by using a percpu variable, but that makes #2 far worse.

Opinions?

[1]: https://lwn.net/Articles/837133/


