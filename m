Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1004FC433FE
	for <linux-unionfs@archiver.kernel.org>; Sun, 13 Dec 2020 19:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B924020754
	for <linux-unionfs@archiver.kernel.org>; Sun, 13 Dec 2020 19:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392540AbgLMTmX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 13 Dec 2020 14:42:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgLMTmX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 13 Dec 2020 14:42:23 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F730C0613D3
        for <linux-unionfs@vger.kernel.org>; Sun, 13 Dec 2020 11:41:37 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id o6so1761736iob.10
        for <linux-unionfs@vger.kernel.org>; Sun, 13 Dec 2020 11:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z07wSqApa7KdylWKlqCudVTxgQybZlnVnQ/+UKjlHAI=;
        b=Uymjlp6SzK5fiZtpC6bJVPiDo13QK9CRAa4LHsnnxRnaZ7hhtztjZ8PMkEvaKl1fxS
         u1xivkvdE4PV8MmTTuDtLg4nj3rlsHpMM3TgG6gHBsQwPl0ugB9P2od0gIWd4hpgeyDk
         jcaU7ZMT0Sfiii6ZVI4G9aKJbXtoEV5a3r+Mw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z07wSqApa7KdylWKlqCudVTxgQybZlnVnQ/+UKjlHAI=;
        b=US2zYtLMRzzco3S5YgktreG0x+jeDBvWfl6uC83kgIlKtpgMiI4w6MUkv8NH3gh2ik
         wYe3FiY/jf/vAzzNfkb8/DNKDjjX3LVG+stcgweuXl0esfNLZznWa7c3IWOs7yToKThr
         1SGDkZNe9INy0CmFmdE6Afd/3YZzc0sVkIfqdHn45HgGJ23+UZS6p+6saJh0RcWxKFiy
         j3jhZ6KGm1umE2fDshoYi0PFXsoLPdZI9XuIce7UUNijQYYccmzBDzbmsPcSZkFzts5N
         stdA4P4IlUztzr4HGnO0ylXfe0ffoS13UYqvt4N4dAZTajOGEFPntburR6JYZz33fjjy
         uRJQ==
X-Gm-Message-State: AOAM533yTtosNrwNKr9cKxIKznSu7syfj/z5KjAt4sgJqdjTtOhipAq6
        ov/Y5PoogBae3j/Q+Qy2s6Rpw8kpga4ylQ==
X-Google-Smtp-Source: ABdhPJxwNSGDdYfgCvBbCqoEX7HGGzRxoojt7wxxWQrVjGgtddc47gzvN9IMWQPyOTpAdUuzN7QNDA==
X-Received: by 2002:a05:6638:24c8:: with SMTP id y8mr28757450jat.63.1607888496615;
        Sun, 13 Dec 2020 11:41:36 -0800 (PST)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id r11sm9697296ilg.39.2020.12.13.11.41.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 13 Dec 2020 11:41:35 -0800 (PST)
Date:   Sun, 13 Dec 2020 19:41:34 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2 2/3] errseq: Add mechanism to snapshot errseq_counter
 and check snapshot
Message-ID: <20201213194133.GA8562@ircssh-2.c.rugged-nimbus-611.internal>
References: <20201211235002.4195-1-sargun@sargun.me>
 <20201211235002.4195-3-sargun@sargun.me>
 <CAOQ4uxgj8LztnH3vD7M=Lp_FoNhoLwaD4CcWQR0T1pd=pe2kgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgj8LztnH3vD7M=Lp_FoNhoLwaD4CcWQR0T1pd=pe2kgA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Dec 12, 2020 at 11:57:52AM +0200, Amir Goldstein wrote:
> Forgot to CC Jeff?
> 
Oops.
> On Sat, Dec 12, 2020 at 1:50 AM Sargun Dhillon <sargun@sargun.me> wrote:
> >
> > This adds the function errseq_counter_sample to allow for "subscribers"
> > to take point-in-time snapshots of the errseq_counter, and store the
> > counter + errseq_t.
> >
> > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > ---
> >  include/linux/errseq.h |  4 ++++
> >  lib/errseq.c           | 51 ++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 55 insertions(+)
> >
> > diff --git a/include/linux/errseq.h b/include/linux/errseq.h
> > index 35818c484290..8998df499a3b 100644
> > --- a/include/linux/errseq.h
> > +++ b/include/linux/errseq.h
> > @@ -25,4 +25,8 @@ errseq_t errseq_set(errseq_t *eseq, int err);
> >  errseq_t errseq_sample(errseq_t *eseq);
> >  int errseq_check(errseq_t *eseq, errseq_t since);
> >  int errseq_check_and_advance(errseq_t *eseq, errseq_t *since);
> > +void errseq_counter_sample(errseq_t *dst_errseq, int *dst_errors,
> > +                          struct errseq_counter *counter);
> > +int errseq_counter_check(struct errseq_counter *counter, errseq_t errseq_since,
> > +                        int errors_since);
> >  #endif
> > diff --git a/lib/errseq.c b/lib/errseq.c
> > index d555e7fc18d2..98fcfafa3d97 100644
> > --- a/lib/errseq.c
> > +++ b/lib/errseq.c
> > @@ -246,3 +246,54 @@ int errseq_check_and_advance(errseq_t *eseq, errseq_t *since)
> >         return err;
> >  }
> >  EXPORT_SYMBOL(errseq_check_and_advance);
> > +
> > +/**
> > + * errseq_counter_sample() - Grab the current errseq_counter value
> > + * @dst_errseq: The errseq_t to copy to
> > + * @dst_errors: The destination overflow to copy to
> > + * @counter: The errseq_counter to copy from
> > + *
> > + * Grabs a point in time sample of the errseq_counter for latter comparison
> > + */
> > +void errseq_counter_sample(errseq_t *dst_errseq, int *dst_errors,
> 
> Why 2 arguments and not struct errseq_counter *dst_counter?
> 

Mostly not to have to use atomic_* when setting this value and avoiding locking 
another cacheline on the CPU. IIRC, atomic_t is always 4-byte aligned but int 
doesn't have to be.

> > +                          struct errseq_counter *counter)
> > +{
> > +       errseq_t cur;
> > +
> > +       do {
> > +               cur = READ_ONCE(counter->errseq);
> > +               *dst_errors = atomic_read(&counter->errors);
> > +       } while (cur != READ_ONCE(counter->errseq));
> 
> This loop seems odd. I think the return value should reflect the fact that
> the snapshot failed and let the caller decide if it wants to loop.
> 
> And about the one and only introduced caller, I think the answer is that
> it shouldn't loop. If volatile overlayfs mount tries to sample the upper sb
> error counter and an unseen error exists, I argued before that I think
> mount should fail, so that the container orchestrator can decide what to do.
> Failure to take an errseq_counter sample means than an unseen error
> has been observed at least in the first or second check.
> 

I guess. In the "good" case, there's the same computational cost, but the bad
case (error occurs while we are snapshotting results in another spin.

> > +
> > +       /* Clear the seen bit to make checking later easier */
> > +       *dst_errseq = cur & ~ERRSEQ_SEEN;
> > +}
> > +EXPORT_SYMBOL(errseq_counter_sample);
> > +
> > +/**
> > + * errseq_counter_check() - Has an error occurred since the sample
> > + * @counter: The errseq_counter from which to check.
> > + * @errseq_since: The errseq_t sampled with errseq_counter_sample to check
> > + * @errors_since: The errors sampled with errseq_counter_sample to check
> > + *
> > + * Returns: The latest error set in the errseq_t or 0 if there have been none.
> > + */
> > +int errseq_counter_check(struct errseq_counter *counter, errseq_t errseq_since,
> > +                        int errors_since)
> > +{
> > +       errseq_t cur_errseq;
> > +       int cur_errors;
> > +
> > +       cur_errors = atomic_read(&counter->errors);
> > +       /* To match the barrier in errseq_counter_set */
> > +       smp_rmb();
> > +
> > +       /* Clear / ignore the seen bit as we do at sample time */
> > +       cur_errseq = READ_ONCE(counter->errseq) & ~ERRSEQ_SEEN;
> > +
> > +       if (cur_errseq == errseq_since && errors_since == cur_errors)
> > +               return 0;
> > +
> > +       return -(cur_errseq & MAX_ERRNO);
> > +}
> 
> 
> Same here. Why not pass an errseq_counter_since argument?
> 
> Thanks,
> Amir.

See above. I can change this, and I mulled over this decision a bunch, 
unfortunately (micro)benchmarking was inconclusive as to whether this made a 
difference or not.

