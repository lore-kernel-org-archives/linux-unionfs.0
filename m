Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB41ECDB46E
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Oct 2023 09:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbjJLJtT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 05:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjJLJtS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2023 05:49:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81BC91
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 02:49:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE974C433C8;
        Thu, 12 Oct 2023 09:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697104157;
        bh=hBqcplrgtHqrhd9xbdX0YZzGe4xCAQyOOrN+4NoJUq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PZRoj6u2S/0ldx9IkshF1JfqxacPBtF0JlY+wOtz3rozsa3Hkye3MrsFEYDn72nU/
         pmDC0bg0LM08jfBW7+p665Ytb3Z1J4Q3xyxAgihlyEHNAVV1sUZe4uNbOnEHIYr0Vb
         8jy36Ffh/uy8i4R7v2oRhqUJiaZ+UBrIvu8mal9ynWp5s3P8peQjdz+tVPuD4NbkTE
         kcF0WZfyNZd9aBzfA1cjH3p53FsrZUI1B0we2YPUV7ygxIYLXsw5kJmiYGwQrsF9c3
         zUs6wcXv684OUGOUotTnMQQ5geDsN523rJvjbscnxePKc39mDPAc7zLe+YzGYe40pm
         N90yMuhPbEq6w==
Date:   Thu, 12 Oct 2023 11:49:12 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Sebastian Wick <sebastian.wick@redhat.com>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
Message-ID: <20231012-bekam-beneiden-eafffa72ab2b@brauner>
References: <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com>
 <CA+hFU4w8mdo1DrWPU3MNM=YBXE9aVD2yFOe_zXXq1U51B0h7kw@mail.gmail.com>
 <CAOQ4uxjhpKU=YfG7KjAYtyQNFzVSpwpYEvPvbMZL_fXssqk1Dg@mail.gmail.com>
 <CAJfpegt3AasPxXt-bX35LB_xP0YXvvETMX98FKJJFK5RX1Q78w@mail.gmail.com>
 <CAOQ4uxgc2YegLuZKg4WLnOCn8-e-hxHJh7LD4=w-x--Fg7fdpw@mail.gmail.com>
 <CAJfpegvLZfYtYo2rbvJOmhbHGE5hoWaoGeb5r4hiTMQOpv0GbQ@mail.gmail.com>
 <CAOQ4uxgBW03c9ZYvKKdD_n1z70fb=+-f6xYLzcZ6AWC3O04cXw@mail.gmail.com>
 <CAJfpegvngPP1KnM7JF4ofdmSVG0XH_NeOC+B97iJZbCgvfAWFw@mail.gmail.com>
 <20231012-klaut-dohle-e87948620243@brauner>
 <CAOQ4uxhU4kh5j55RpvD7=vkagySTbbvc=CqLv6sxk5114k4Kvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhU4kh5j55RpvD7=vkagySTbbvc=CqLv6sxk5114k4Kvg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Oct 12, 2023 at 12:27:26PM +0300, Amir Goldstein wrote:
> On Thu, Oct 12, 2023 at 11:26 AM Christian Brauner <brauner@kernel.org> wrote:
> >
> > > > Christian,
> > > >
> > > > Do you know any userspace that already uses your new append prefixes?
> > > > Do we have any good reason to support "lowerdir_first"
> > > > so a lower dir stack could be reset before creating the sb?
> > >
> > > If that is a requirement, I suggest extending fsconfig(2) to allow
> > > resetting an option.
> >
> > Overlayfs does already support this. If you pass:
> > fsconfig(FSCONFIG_SET_STRING, "lowerdir", "", ...)
> > then the lower layer stack is reset. I've implemented it that way in
> > ovl_parse_param_lowerdir().
> >
> 
> Yes, I noticed that. Cool.
> 
> > >
> > > > > > > >
> > > > > > > > Anyway, let's focus on what you would like best.
> > > > > > > > If you prefer to just fix the regression, it is doable.
> > > > > > > > If you prefer the upperdirfd, workdirfd, lowerdirfd API, I think we can
> > > > > > > > find a volunteer to write it up.
> > >
> > > Can't the existing option names be overloaded if a separate cmd
> > > (FSCONFIG_SET_PATH or FSCONFIG_SET_PATH_EMPTY) is used in fsconfig()?
> >
> > Yes, they can and filesystems do do that today depending on whether they
> > want to e.g., take an fd or a path or something.
> 
> Nice. It seems like Miklos has volunteered to implement the
> dirfd and/or unescaped API variants for the new mount API :)
> 
> What is your opinion about the original regression report
> regarding escaping of commas in ->parse_monolithic()?
> 
> It's easy to implement ovl_parse_monolithic() that will
> conform to the old ovl_next_opt() behavior, but it does not
> solve the problem long term.
> 
> If there are currently setups in the wild that pass arguments
> like [lowerdir=/tmp/a\,b/], even if I do fix up ovl_parse_monolithic()
> those setups will regress when they upgrade to libmount v2.39,
> because AFAICT, libmount does not respect "\," to escape option split,
> it respects [lowerdir="/tmp/a,b/"] to escape option split.

For full backward compatibility we would probably need to fix both the
kernel and libmount. Because libmount/mount(8) is encouraged to split a
lowerdir=/a:/b:/c:/d option into separate fsconfig calls, especially
when dealing with really long paths. So libmount would need to be aware
of overlayfs parsing behavior that includes escaping \, even if we fix
the kernel itself.

I don't think that would be a big deal because libmount already has to
deal with all kinds of filesystems specific quirks.

However, libmount also added LIBMOUNT_FORCE_MOUNT2={always,never,auto}
which can be used to disable using the new mount api and makes it use
the old mount api which is available in libmount 2.39.

So I think complementing overlayfs with a ->parse_monolithic() option
might be something that we could consider doing but this is a judgement
call there's not clear right and wrong with so many moving parts...

> 
> If we do decide that we need to or want to fix ->parse_monolithic()
> then do you think it would make sense to respect "\," escaping in
> generic_parse_monolithic()?
> I cannot imagine any workload that would get regressed by this
> (famous last words).

I'm pretty sure that this would break something so I would be hesitant
doing this.
