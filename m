Return-Path: <SRS0=do5T=BW=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF228C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Aug 2020 16:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9F1220675
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Aug 2020 16:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgHLQFV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 12:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgHLQFV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Aug 2020 12:05:21 -0400
X-Greylist: delayed 7783 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Aug 2020 09:05:20 PDT
Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [IPv6:2001:19f0:5:727:1e84:17da:7c52:5ab4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D607FC061383
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Aug 2020 09:05:20 -0700 (PDT)
Received: from kevinolos (host-69-145-60-23.bln-mt.client.bresnan.net [69.145.60.23])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 1B6F01B5900C;
        Wed, 12 Aug 2020 16:05:15 +0000 (UTC)
Received: by kevinolos (Postfix, from userid 1000)
        id 137C21305F75; Wed, 12 Aug 2020 10:05:13 -0600 (MDT)
Date:   Wed, 12 Aug 2020 10:05:13 -0600
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: EIO for removed redirected files?
Message-ID: <20200812160513.GA249458@kevinolos>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
References: <20200812135529.GA122370@kevinolos>
 <CAOQ4uxih2aDb7_LPSUb5Q4xBL5_gDaqtmC0M0M4EtCDgKLvi3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxih2aDb7_LPSUb5Q4xBL5_gDaqtmC0M0M4EtCDgKLvi3w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Thanks for the quick response Amir!

On Wed, 2020-08-12 at 18:21 +0300, Amir Goldstein wrote:
> On Wed, Aug 12, 2020 at 5:06 PM Kevin Locke <kevin@kevinlocke.name> wrote:
>> I recently encountered files on an overlayfs which returned EIO
>> (Input/output error) for open, stat, and unlink (and presumably other)
>> syscalls.  I eventually determined that the files had been redirected
> 
> It's *empty* redirected files that cause the alleged problem.

When I replace `touch foo.txt` with `echo 123 > foo.txt` I observe the
same behavior.  If I understand you correctly, you are saying that EIO
is correct for non-empty files, but potentially incorrect for empty
files (which could be copied rather than redirected, since there is no
space saving)?

>> At this point, the only way to recover appears to be unmounting the
>> overlay and removing the file from upper (or updating the
>> overlay.redirect xattr to a valid location).  Is that correct?
>>
>> Is this the intended behavior?
> 
> Yes.
> What would you expect to happen when data of metacopy file has been removed?

After reflection, EIO probably makes the most sense for open/stat.  It
might be nice to be able to unlink the file to allow recovery (in the
sense of being able to reuse the name) without unmounting the overlay,
but the documentation updates may be sufficient to keep users from
getting into this state.

>> unionmount-testsuite.  If so, perhaps the behavior could be noted in
>> "Changes to underlying filesystems" in
>> Documentation/filesystems/overlayfs.rst?  I'd be willing to write a
>> first draft.  (I doubt I understand it well enough to get everything
>> right on the first try.)
> 
> I guess the only thing we could document is that changes to underlying
> layers with metacopy and redirects have undefined results.
> Vivek was a proponent of making the statements about outcome of
> changes to underlying layers sound more harsh.

That sounds good to me.  My current use case involves offline changes to
the lower layer on a routine basis, and I interpreted the current
wording "Offline changes, when the overlay is not mounted, are allowed
to either the upper or the lower trees." to mean that such offline
modifications would not break things in unexpected ways.

In retrospect, I should have expected this behavior, but as someone
previously unfamiliar with overlayfs, I hadn't considered that metacopy
results in file redirects and that if the underlying file were removed
without removing any redirects pointing to it that it would manifest in
this way and be so difficult to clean up.

If metacopy and dir_redirect are disabled, are offline modifications to
the lower layer permitted, or could any such modification result in
undefined behavior?

>> Also, if there is any way this could be made easier to debug, it might
>> be helpful for users, particularly newbies like myself.  Perhaps logging
>> bad redirects at KERN_ERR?  If that would be too noisy, perhaps only
>> behind a debug module option?  Again, if this is acceptable I'd be
>> willing to draft a patch.  (Same caveat as above.)
> 
> There are a handful of places in overlayfs where returning EIO is
> combined with informative pr_warn_ratelimited().

Ah, indeed.  Would doing so for missing/invalid metacopy/redirect make
sense?

> You can see some examples in ovl_lookup(), which is where the reported
> EIO is coming from:
>         if (d.metacopy || (uppermetacopy && !ctr)) {
>                 err = -EIO;
> 
> Having said all that, metacopy and redirects on lower empty files seems
> like an unintentional outcome.
> 
> If you care about this use case particularly, you may try this untested patch:

Thanks for the patch!  (Especially so quickly.)  I'll try it out soon.

Thanks again,
Kevin
