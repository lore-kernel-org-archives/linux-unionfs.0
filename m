Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB42C433DB
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Dec 2020 12:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A13CB224BE
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Dec 2020 12:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgLWMox (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Dec 2020 07:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgLWMox (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Dec 2020 07:44:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F0A62246B;
        Wed, 23 Dec 2020 12:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608727452;
        bh=Wu/mGDeCTn4QTu5/yjEsGA9s3BZZtkm9lCThXqCK1io=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FOE9ne1ynoubP+71zhE4C8BQB1LttPmR2V3ruurelMtpJYhIWgCzQtkPolJuYyeqT
         qeWqxZC1aR0VjxYu4NAlnW8zso+5OzMiY/HnSMCJSRNTh+Gtde9hlPzOcDgpyPCUJa
         LUYxWFiTTSiOx9KhaZ8b3QhEp/BDTUk4bs4yPt3Zi474NWwEMPcc9U5paNDw48RjJZ
         EfqDgtubvIraCkVRFTLLv8pZqFKnwR4GT1q8OwElNLvaDqcabeQoJv0mUUAfzh7Fgm
         emPNG82eMNlGQRN7Wbeb+BZykBXA8jo0sSnJspvR41qwJNOmFFlgOAO+3K/PIzhEoB
         kwKo85Aocp9Sw==
Message-ID: <6c60d0e19af9a820aae15cd3477da561115c9852.camel@kernel.org>
Subject: Re: [PATCH 2/3] vfs: Add a super block operation to check for
 writeback errors
From:   Jeff Layton <jlayton@kernel.org>
To:     Vivek Goyal <vgoyal@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        sargun@sargun.me, miklos@szeredi.hu, jack@suse.cz, neilb@suse.com,
        viro@zeniv.linux.org.uk, hch@lst.de
Date:   Wed, 23 Dec 2020 07:44:10 -0500
In-Reply-To: <20201222162509.GB3248@redhat.com>
References: <20201221195055.35295-1-vgoyal@redhat.com>
         <20201221195055.35295-3-vgoyal@redhat.com>
         <20201222161900.GI874@casper.infradead.org>
         <20201222162509.GB3248@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 2020-12-22 at 11:25 -0500, Vivek Goyal wrote:
> On Tue, Dec 22, 2020 at 04:19:00PM +0000, Matthew Wilcox wrote:
> > On Mon, Dec 21, 2020 at 02:50:54PM -0500, Vivek Goyal wrote:
> > > -	ret2 = errseq_check_and_advance(&sb->s_wb_err, &f.file->f_sb_err);
> > > +	if (sb->s_op->errseq_check_advance)
> > > +		ret2 = sb->s_op->errseq_check_advance(sb, f.file);
> > 
> > What a terrible name for an fs operation.  You don't seem to be able
> > to distinguish between semantics and implementation.  How about
> > check_error()?
> 
> check_error() sounds better. I was not very happy with the name either.
> Thought of starting with something.
> 

Maybe report_error() ?

The same error won't be reported on the next call on the same fd. I
think the important point to make here is that this error must be
reported to syncfs() or something like it once you call this.

(In hindsight, I sort of wish I had done s/serrseq_set/errseq_record/
and s/errseq_check_and_advance/errseq_report/ when I initially did this,
if only to make the API a little less dependent on the implementation.)
-- 
Jeff Layton <jlayton@kernel.org>

