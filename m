Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6727EC433FE
	for <linux-unionfs@archiver.kernel.org>; Mon,  7 Nov 2022 07:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiKGHG1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 02:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiKGHG0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 Nov 2022 02:06:26 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CE012766
        for <linux-unionfs@vger.kernel.org>; Sun,  6 Nov 2022 23:06:26 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id q9so9771156pfg.5
        for <linux-unionfs@vger.kernel.org>; Sun, 06 Nov 2022 23:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wT2kcaw2SNda/RDQqeGFsu4gi3C9YlrOrmb+imgaDLg=;
        b=XO6qVMYyBpDT5b6LZLkkafkI8nNd34m6DFSKmu7aCevpTCcALWaBWwOUdwjIKG6rA2
         34bcCO+XlGhOEZBZWHnZRTxlwwm1uz7cGuxarh9QTjsB/SYkqsjwzFHM12JpE8d871pS
         JyrOW+l2bCv/XI7YOFYPR+FIkIgOImL/j8x3pwa9+QwM3/ocMEbljydedf8fY0NMsDSB
         IrJzoLwgsQxP9dE5uiZqc+hXKFRSoZHIoO4kaPbuO3cRNyK9VXj1qtDVhDIeWwLI6lOP
         KhdiSb+g6jHfbkZCg4uCx+OePsnnLx7tefFBAaSO7VcvdKsYfzDGb3y8u/pDr0JqRUnn
         da1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wT2kcaw2SNda/RDQqeGFsu4gi3C9YlrOrmb+imgaDLg=;
        b=8FVqrOwfWTN8reFfSAAvjQSHE2TknpKcL4PiLB94r2xTYwnuIo8jpXmsiZhJbYmfLq
         8g4NoNf38dp77sb/EOyQGZMfSZOUiZ1HDqE/HxHMIlAdAJW3LOj7XN7RmAbxiz1wUQd5
         GOcWJNDas+y+X4h6qKkNyOmR2++tRr5Fm6WBpFLC3WLmEwAjpK44qUHwMgcAjC1o7iZi
         LxYvPUnSNogRO895bd+H5m7zVxMRHcJN17G3Fuemd+kvGk8VY0BxhsSN/IbXGaBYIg7T
         Gx6qnusGBy5LMCwuPg2XSxLrRlR5uvHN2BvNEtDyb+yMuqS1QeXPKzMoFkvm7zxP8HGC
         mbXA==
X-Gm-Message-State: ACrzQf1L54DPnmC6H/Aj7ISOicCCBOkHC/SKTKdhIgPtwbg49o9/GL8p
        p0pktX+t9lR2BstyDMfum7KbZ0pEOuk=
X-Google-Smtp-Source: AMsMyM40o3buubXTlOGYundwLD+MRnJZi9/mD5Txh/92Tc6Da/2We1OVXNo/U6FLtkDbFwG9kmFNzg==
X-Received: by 2002:a63:ea4a:0:b0:439:4695:c0f8 with SMTP id l10-20020a63ea4a000000b004394695c0f8mr41513067pgk.440.1667804785701;
        Sun, 06 Nov 2022 23:06:25 -0800 (PST)
Received: from ubuntu ([210.99.119.32])
        by smtp.gmail.com with ESMTPSA id z16-20020a170903019000b001865e69b4d7sm4203146plg.264.2022.11.06.23.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 23:06:25 -0800 (PST)
Date:   Sun, 6 Nov 2022 23:06:21 -0800
From:   "YoungJun.Park" <her0gyugyu@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org
Subject: Re: Re: Question about ESTALE error whene deleting upper directory
 file.
Message-ID: <20221107070621.GA1860348@ubuntu>
References: <20221107042932.GB1843153@ubuntu>
 <CAOQ4uxipsS3Xf00fvY4fEBgJX8MZK2VW8sHANLA6h8qoEeAiCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxipsS3Xf00fvY4fEBgJX8MZK2VW8sHANLA6h8qoEeAiCA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Nov 07, 2022 at 08:40:02AM +0200, Amir Goldstein wrote:
> On Mon, Nov 7, 2022 at 6:38 AM YoungJun.Park <her0gyugyu@gmail.com> wrote:
> >
> > Here is my curious scenario.
> >
> > 1. create a file on overlayfs.
> > 2. delete a file on upper directory.
> > 3. can see file contents using read sys call. (may file operations all success)
> > 4. cannot remove, rename. it return -ESTALE error (may inode operations fail)
> >
> > I understand this scenario onto the code level.
> > But I don't understand this situation itself.
> >
> > I found a overlay kernel docs and it comments
> > Changes to underlying filesystems section
> >
> > ...
> > Changes to the underlying filesystems while part of a mounted overlay filesystem are not allowed.
> > If the underlying filesystem is changed, the behavior of the overlay is undefined,
> > though it will not result in a crash or deadlock.
> > ....
> >
> > So here is my question (may it is suggestion)
> >
> > 1. underlying file system change is not allowed, then how about implementing shadow upper directory from user?
> > 2. if read, write system call is allowed, how about changing remove, rename(and more I does not percept) operation success?
> >
> 
> What is your use case?
> Why do you think this is worth spending time on?
> If anything, we could implement revalidate to return ESTALE also from open
> in such a case.
> But again, why do you think that would matter?
> 
> Thanks,
> Amir.

Thank you for replying.
I develop antivirus scanner.
When developing, I am confronted the situaion below.

1. make a docker container using overlayfs
2. our antivirus scanner detect on upperdir and remove it.
3. When I check container, the file contents can be read, buf file cannot be removed.(-ESTALE error)

And as I think, the reason is upperdir is touchable. So it is better to hide upperdir.
If it is hard to implement(or maybe there is a other reson that I don' know)
it is better to make the situation is clear 
(file operation error, inode operations error or file operation success , inode operation success)

Thank you again Amir.
Best regards
