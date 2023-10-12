Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D53DCDB46E
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Oct 2023 08:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbjJLIWE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 04:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbjJLIWD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2023 04:22:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709D498
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 01:22:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827A4C433C7;
        Thu, 12 Oct 2023 08:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697098921;
        bh=Q9NOrGtAwiLexeBJCbfCEzfE91RiWEUv25B5sGyCt2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rCDecUdwAUMXlk7XLt3DUapDsj1S9296uuZwbzg5+zQD9Uv7tYmmRrF08SEwOOucX
         mVYWqVcGeIM91qtNsDYPEyqVcywSzM6sgruwinOYJG9pJ2Aj7S7McjzNBHGQ5Jk2qf
         SWHWRgzqvJOlyged62bk8jBCIdwsbilXf7NusyFHvcpFelgrj0+sbrQifBJYbftbpL
         9O+B344PYO+LKmjI4+X6ooDPSxij2SCpx0QSZaK6RLmI9sDFeri5VoExbpSsYHkk5g
         7TH6gzmK3OyIHR1PbX9nn92ghMr7QkDkF7HKF8RBQCB/Wfv4UmsUBHiSX8c8v/Xzo1
         RFs31ELVmSIyQ==
Date:   Thu, 12 Oct 2023 10:21:56 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Sebastian Wick <sebastian.wick@redhat.com>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
Message-ID: <20231012-neugliederung-glimpflich-444037247596@brauner>
References: <CAJfpegsFNjMX+Lz8uX-6=fDa59qYJQjnUnJpzKiTxuBziC7pxQ@mail.gmail.com>
 <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com>
 <CA+hFU4w78Ze-wKPg9fsdR6zpL5VUwp8jNqCcHGmOFJ--GAGKJA@mail.gmail.com>
 <CAOQ4uxhSTJaZggq-z_3oPbXh48n88E1QjfNTr5HO1ZuqyrF+ew@mail.gmail.com>
 <CA+hFU4w8mdo1DrWPU3MNM=YBXE9aVD2yFOe_zXXq1U51B0h7kw@mail.gmail.com>
 <CAOQ4uxjhpKU=YfG7KjAYtyQNFzVSpwpYEvPvbMZL_fXssqk1Dg@mail.gmail.com>
 <CAJfpegt3AasPxXt-bX35LB_xP0YXvvETMX98FKJJFK5RX1Q78w@mail.gmail.com>
 <CAOQ4uxgc2YegLuZKg4WLnOCn8-e-hxHJh7LD4=w-x--Fg7fdpw@mail.gmail.com>
 <CAJfpegvLZfYtYo2rbvJOmhbHGE5hoWaoGeb5r4hiTMQOpv0GbQ@mail.gmail.com>
 <CAOQ4uxgBW03c9ZYvKKdD_n1z70fb=+-f6xYLzcZ6AWC3O04cXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxgBW03c9ZYvKKdD_n1z70fb=+-f6xYLzcZ6AWC3O04cXw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Oct 11, 2023 at 03:06:49PM +0300, Amir Goldstein wrote:
> On Wed, Oct 11, 2023 at 1:18 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Wed, 11 Oct 2023 at 10:45, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > >
> > > We could add new keys:
> > > lowerdir_first=,lowerdir_next=,lowerdatadir_next=
> > > as explicit variants for the "[^:]",":","::" prefix detection
> > > and those don't need to be unescaped.
> >
> > Good idea.  I'd merge "lowerdir_first" and "lowerdir_next" into
> > "lowerdir_one" or whatever for simplicity.  I'd also consider dropping
> > the prefix detection, since it has only been in mainline for one
> > cycle.
> >
> 
> OK.
> 
> Christian,
> 
> Do you know any userspace that already uses your new append prefixes?

I'm not sure if @Karel already ported libmount to rely on this.
The new layer parsing where you can append and replace layers was done
so that we can have the maximum number of allowed lower layers.

So in the future I would expect libmount should parse the lowerdir,
upperdir, workdir strings and split them up in userspace before passing
them to the kernel.
