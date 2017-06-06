From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: Unique st_ino/st_dev for non-samefs
Date: Tue, 06 Jun 2017 20:08:36 +0530
Message-ID: <2513918.i5T46bDxsg@localhost.localdomain>
References: <CAOQ4uxiKwEWk3bJnWn=754RcS4eH0f+4nT33TzHGSdOV+d4Azw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46565 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751433AbdFFOjP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Jun 2017 10:39:15 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v56EYcFI022643
        for <linux-unionfs@vger.kernel.org>; Tue, 6 Jun 2017 10:39:15 -0400
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2awmurdng3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Jun 2017 10:39:15 -0400
Received: from localhost
        by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 7 Jun 2017 00:39:12 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
        by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v56Ed2fg2883928
        for <linux-unionfs@vger.kernel.org>; Wed, 7 Jun 2017 00:39:10 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
        by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v56Eca0P009195
        for <linux-unionfs@vger.kernel.org>; Wed, 7 Jun 2017 00:38:36 +1000
In-Reply-To: <CAOQ4uxiKwEWk3bJnWn=754RcS4eH0f+4nT33TzHGSdOV+d4Azw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org

On Monday, June 5, 2017 10:05:16 PM IST Amir Goldstein wrote:
> On Mon, Jun 5, 2017 at 6:07 PM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> >
> > Hi Amir,
> >
> > I realized only now that I misunderstood the problem statement. Now I am
> > confused. Apologies for bringing this up so late.
> >
> > With the code from ovl-constino branch, I see that ovl_getattr() already
> > generates unique and constant (for the duration of fs 'mount' cycle atleast)
> > combinations of (st_ino, st_dev).
> >
> > In the cover letter of the "Constant Inode numbers" patchset, you had
> > mentioned "System-wide unique st_dev;st_ino for non-samefs" as the
> > TODO. From the code in ovl_getattr() I feel that we are already generating
> > filesystem-wide unique combinations of (st_dev, st_ino).
> >
> > I understand that I am missing something here. Could you please point out the
> > case where we don't yet have system-wide unique (st_dev, st_ino) combination?
> >
> 
> Sure. You are missing a subtle detail.
> From Documentation/filesystems/overlayfs.txt:
> 
> "This approach is 'hybrid' because the objects that appear in the
> filesystem do not all appear to belong to that filesystem.  In many
> cases an object accessed in the union will be indistinguishable
> from accessing the corresponding object from the original filesystem.
> This is most obvious from the 'st_dev' field returned by stat(2)."
> 
> And for v4.12, I added this text:
> "In the special case of all overlay layers on the same underlying
> filesystem, all objects will report an st_dev from the overlay
> filesystem and st_ino from the underlying filesystem.  This will
> make the overlay mount more compliant with filesystem scanners and
> overlay objects will be distinguishable from the corresponding
> objects in the original filesystem."
> 
> So the case where we don't yet have system-wide unique (st_dev/st_ino)
> is the file /lower/foo has the same st_dev/st_ino as the file /mnt/foo,
> where /mnt is an overlay of /lower and /upper on not same fs.
> And what is worse, as Miklos pointed out is that after copy up,
> /mnt/foo with still have the same st_dev/st_ino as /lower/foo,
> but now they will have a different data and diff won't know it, because
> it does not bother to compare data when st_dev/st_ino are equal.

Amir, Thanks for the clarification. I was under the assumption that we would
not support the usecase wherein the userspace programs would access files on
overlayfs and files on the lowerdir simultaneously. 

I have coded up the fake st_dev part. The fake st_devs are obtained using 
get_anon_bdev(). I am now working on enhancing the tests.

> 
> The solution is quite simple and therefore the task itself is quite simple,
> mostly the challenge is to write the tests for the use cases.
> 
> All you need to do at  overlay mount time, for non-samefs case, is to
> allocate a fake st_dev value for each layer (or for each unique fs) and
> store those values in the  ovl_fs private struct.
> 
> Then the code in ovl_getattr() will simply set those fake st_dev values
> instead of the rel values, for example:
> 
> @@ -110,6 +110,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>                 }
>                 if (samefs)
>                         stat->dev = dentry->d_sb->s_dev;
> +               else
> +                       stat->dev = ovl_fake_dev(stat->s_dev);
>         } else {
>                 /*
>                  * Always use the overlay st_dev for directories, so 'find
> 
> I am not sure how sdev id's are allocated for anonymous devices
> (like the overlay sdev itself), but it is possible to reserve a namespace for
> overlayfs then maybe the conversion ovl_fake_dev() can be static - I doubt it.
> More likely this would have to be a lookup in the fake id's by real id's map
> that you created at mount time.
> 
> Let me know if you need more clarifications.
> 


-- 
chandan
