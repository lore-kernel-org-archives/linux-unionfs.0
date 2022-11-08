Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98279C4332F
	for <linux-unionfs@archiver.kernel.org>; Tue,  8 Nov 2022 08:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbiKHIOP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiKHIOO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 Nov 2022 03:14:14 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C777220191
        for <linux-unionfs@vger.kernel.org>; Tue,  8 Nov 2022 00:14:13 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i3so13118036pfc.11
        for <linux-unionfs@vger.kernel.org>; Tue, 08 Nov 2022 00:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=beYitm9omSsPyE2efX1OoUEkZ/GDQpfISlzJSwFt4+A=;
        b=Ifxs+DybgdNzyq1dRxfh3xqOervMI0/lfz2zSViTA/02W1I02FKlPKGixhTynSs+Sn
         9C76mAYGYLPhHxYoSGXkB1jrxocpUQxOkNRJI8Rz44baIjchpxdxs5zDhLwDTxSXvep4
         Hm8kYm8dTQLfVYiGFfKI09i4DGOIXxSUb/9HBgYlpdnNhd512q5UMP+oy874M87bQDjJ
         a/Kd0rc59r5/alxhivd1GZsp2ORMVdRiEGWx4OIXdWidvCrfu2rOYoUrx4OxJOe/F2Qt
         L+SXwPs4TwDTWRdp8d8IhTOBmvA/WGwoLwhx+H4eeArWd9rv+q8nGrg2L285Ur2iQtcb
         9g9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=beYitm9omSsPyE2efX1OoUEkZ/GDQpfISlzJSwFt4+A=;
        b=FWUXY1hdaifKL49gSPSD3q5UNTO1emETGEFod+cF+bmmX6kzM/mbG4GKRrAI2nupfE
         dClVgfsOSrXRIWYTXpXViOPqLkQcfBAV7ceG9Lml3tp1jGR42PLVbqu6iE0W3+tLzkE5
         4IaJ4D7av+t2342FYY6sF6dPWIjVOJ9+5R/FlCGY98bLcp7uNmYCag1XxmZCJYg33/5u
         kjOpBTlIh9kTl+ehbaXqXLL9ejMXvuuqZfIefIgUfnFBpwwY1JRivFjRYche+NY9WrWe
         fqy+SzikTWRix3xLm1bnpoPOiBu8K1nev5hWCMxVHaeMzwy8TS8jgoDsGYvTJaEy6U7g
         XpUw==
X-Gm-Message-State: ACrzQf0Y0KdFPCipL2O6vNsvoKbnd5aTxflWF9aSBsTiO+vj3F3KcPNS
        2+9ZODHqG5tJVH68WISbLibX45H1bNY=
X-Google-Smtp-Source: AMsMyM5QaiFaLTF6t7nVUKuN3H8KJgbfzGkq1V1JgjnkXVuH8udyW2VKzG+gZrhh67Ax6jAtcPM4kA==
X-Received: by 2002:a65:68c1:0:b0:46e:e9c3:2ff1 with SMTP id k1-20020a6568c1000000b0046ee9c32ff1mr47363609pgt.510.1667895253153;
        Tue, 08 Nov 2022 00:14:13 -0800 (PST)
Received: from ubuntu ([210.99.119.32])
        by smtp.gmail.com with ESMTPSA id c17-20020a170902d49100b001754cfb5e21sm6308674plg.96.2022.11.08.00.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 00:14:12 -0800 (PST)
Date:   Tue, 8 Nov 2022 00:14:08 -0800
From:   "YoungJun.Park" <her0gyugyu@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org
Subject: Re: Re: Question about ESTALE error whene deleting upper directory
 file.
Message-ID: <20221108081408.GA16209@ubuntu>
References: <20221107042932.GB1843153@ubuntu>
 <CAOQ4uxipsS3Xf00fvY4fEBgJX8MZK2VW8sHANLA6h8qoEeAiCA@mail.gmail.com>
 <20221107070621.GA1860348@ubuntu>
 <CAOQ4uxg6ZsWKqgRBTxfXkfYP0xpf7CvpYsc7aj_1SgvDGYLjJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg6ZsWKqgRBTxfXkfYP0xpf7CvpYsc7aj_1SgvDGYLjJA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Nov 07, 2022 at 10:49:57AM +0200, Amir Goldstein wrote:
> On Mon, Nov 7, 2022 at 9:06 AM YoungJun.Park <her0gyugyu@gmail.com> wrote:
> >
> > On Mon, Nov 07, 2022 at 08:40:02AM +0200, Amir Goldstein wrote:
> > > On Mon, Nov 7, 2022 at 6:38 AM YoungJun.Park <her0gyugyu@gmail.com> wrote:
> > > >
> > > > Here is my curious scenario.
> > > >
> > > > 1. create a file on overlayfs.
> > > > 2. delete a file on upper directory.
> > > > 3. can see file contents using read sys call. (may file operations all success)
> > > > 4. cannot remove, rename. it return -ESTALE error (may inode operations fail)
> > > >
> > > > I understand this scenario onto the code level.
> > > > But I don't understand this situation itself.
> > > >
> > > > I found a overlay kernel docs and it comments
> > > > Changes to underlying filesystems section
> > > >
> > > > ...
> > > > Changes to the underlying filesystems while part of a mounted overlay filesystem are not allowed.
> > > > If the underlying filesystem is changed, the behavior of the overlay is undefined,
> > > > though it will not result in a crash or deadlock.
> > > > ....
> > > >
> > > > So here is my question (may it is suggestion)
> > > >
> > > > 1. underlying file system change is not allowed, then how about implementing shadow upper directory from user?
> > > > 2. if read, write system call is allowed, how about changing remove, rename(and more I does not percept) operation success?
> > > >
> > >
> > > What is your use case?
> > > Why do you think this is worth spending time on?
> > > If anything, we could implement revalidate to return ESTALE also from open
> > > in such a case.
> > > But again, why do you think that would matter?
> > >
> > > Thanks,
> > > Amir.
> >
> > Thank you for replying.
> > I develop antivirus scanner.
> > When developing, I am confronted the situaion below.
> >
> > 1. make a docker container using overlayfs
> > 2. our antivirus scanner detect on upperdir and remove it.
> > 3. When I check container, the file contents can be read, buf file cannot be removed.(-ESTALE error)
> >
> > And as I think, the reason is upperdir is touchable. So it is better to hide upperdir.
> > If it is hard to implement(or maybe there is a other reson that I don' know)
> > it is better to make the situation is clear
> > (file operation error, inode operations error or file operation success , inode operation success)
> >
> 
> Error on read is not an option because reading from an open and deleted
> file is perfectly valid even without overlayfs.
> 
> ESTALE error on open is doable and makes sense and I believe it may
> be sufficient for your use case.
> 
> I have an old branch that implements that behavior:
> https://github.com/amir73il/linux/commits/ovl-revalidate
> 
> You can try it out and see if that works for you.
> If it does, I can post the patches.
> 
> Note that the use case that you described does not need the last patch,
> but if the anti-virus would have moved a lower file to quarantine
> instead of deleting it, the last patch would also be useful for you.
> 
> Thanks,
> Amir.

After applying the branch, I tested the scenario.
But it does not work. file open is success on overlayfs filesystem.

In my scnario, the dentry is not negative and just unhashed on upper.
If we check dentry is unhashed we properly block open on my scenario.
I write the patch and tested it working.
(Maybe I does not catch your point, if you give a guide then I follow it)

Signed-off-by: YoungJun.park <her0gyugyu@gmail.com>
---
 fs/overlayfs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 6512d147c223..629dbcc49070 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -157,6 +157,10 @@ static int ovl_open(struct inode *inode, struct file *file)
    file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);

    ovl_path_realdata(dentry, &realpath);
+
+    if (d_unhashed(realpath.dentry))
+        return -ESTALE;
+
    realfile = ovl_open_realfile(file, &realpath);
    if (IS_ERR(realfile))
        return PTR_ERR(realfile);
--
2.25.1

And I have one more question.
Why upper dir must be visible..?  
The reson I think making upper dir unvisible is like the below.
1. If making a upperdir is unvisible, then these kind of problem disappear.
2. upperdir visibility makes a passage to convey container's file to hostland. 
(in view of container using overlayfs)
making unvisible remove this kind of problem.
3. Changing upper dir scenario makes undefined behavior. So, if removing the interface
user can access, then we can make the undefined scenario itself.

Thanks Amir.
Best regards
