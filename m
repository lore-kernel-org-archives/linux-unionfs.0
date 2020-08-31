Return-Path: <SRS0=nzN1=CJ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28362C433E7
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F323E20719
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 Aug 2020 13:48:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="foKzUdRc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgHaNsS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 09:48:18 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17191 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727786AbgHaNsR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 31 Aug 2020 09:48:17 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1598881632; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=Gja5Sfv9l2Kt8jPPMttMIcKNIVl3SuJvuvh/1uoKrIZ2mlY5ClKaJ2sIL2BUYQ43C8O0OBOMIA0OM8wSnI7fHu0SjqOrMd9qTTiIKQqcvRDZX1LaLw8UELwwToy75zhzp18wbq+xMgRK2OA+Io858U+vZIRQShNoAbW2Bw5LcFU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1598881632; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=eX9Ln3ZLMpVj4uDsRbZpaJVlp7X48vtTXzB/H1V5WIs=; 
        b=T7ZLLNbr+xfAjKbfdCVao5zEiSjdIJUYo/w+GJDJnZz7HNYA3SnTe6Una8NkfcZTFbCocYrZVLMmyta29YFLmx2f3/0/a26uVS7vBz15tjUmqKarwxNbFdqbS7RK6Wm13oKLi8r2/DkhcvJ6bz+63mXDFWl3PRQoiiCPaK7Otew=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1598881632;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=eX9Ln3ZLMpVj4uDsRbZpaJVlp7X48vtTXzB/H1V5WIs=;
        b=foKzUdRcaUpoILOEOVWiwpVhyCehg4VGUP2m8pPaN/g3KrqfjicwPWgRDzz90F0N
        8zDa8XWQk2Fo7BKXWqSO6kLBJcmNhgMErlL+FYG+T2IbYJewdYoH9trsal+ROXbdSTS
        zjNImGt9fbg2AQuGfbQ3/pF9sK4xWIwOjLBnvdRg=
Received: from [10.0.0.2] (113.88.135.106 [113.88.135.106]) by mx.zoho.com.cn
        with SMTPS id 1598881629062550.3876028156856; Mon, 31 Aug 2020 21:47:09 +0800 (CST)
Subject: Re: [RFC PATCH 3/3] ovl: implement stacked mmap for shared map
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <riteshh@linux.ibm.com>
References: <20200829095101.25350-1-cgxu519@mykernel.net>
 <20200829095101.25350-4-cgxu519@mykernel.net>
 <CAOQ4uxisdtoccDoQe_fYUA-jXTfy0yk=gNcMSrmbkCYaeOEPuQ@mail.gmail.com>
From:   cgxu <cgxu519@mykernel.net>
Message-ID: <e1e2c8f0-a3b8-0a3d-3093-6188b1a829f0@mykernel.net>
Date:   Mon, 31 Aug 2020 21:47:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxisdtoccDoQe_fYUA-jXTfy0yk=gNcMSrmbkCYaeOEPuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoCNMailClient: External
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 8/30/20 7:33 PM, Amir Goldstein wrote:
> On Sat, Aug 29, 2020 at 12:51 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>>
>> Implement stacked mmap for shared map to keep data
>> consistency.
>>
>> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>> ---
>>   fs/overlayfs/file.c | 120 +++++++++++++++++++++++++++++++++++++++++---
>>   1 file changed, 114 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
>> index 14ab5344a918..db5ab200d984 100644
>> --- a/fs/overlayfs/file.c
>> +++ b/fs/overlayfs/file.c
>> @@ -21,9 +21,17 @@ struct ovl_aio_req {
>>          struct fd fd;
>>   };
>>
>> +static vm_fault_t ovl_fault(struct vm_fault *vmf);
>> +static vm_fault_t ovl_page_mkwrite(struct vm_fault *vmf);
>> +
>> +static const struct vm_operations_struct ovl_vm_ops = {
>> +       .fault          = ovl_fault,
>> +       .page_mkwrite   = ovl_page_mkwrite,
>> +};
>> +
> 
> Interesting direction, not sure if this is workable.
> I don't know enough about mm to say.
> 
> But what about the rest of the operations?
> Did you go over them and decide that overlay doesn't need to implement them?
> I doubt it, but if you did, please document that.

I did some check for rest of them, IIUC ->fault will be enough for this 
special case (shared read-only mmap with no upper), I will remove 
->page_mkwrite in v2.

# I do not consider support ->huge_fault in current stage due to many fs 
cannot support DAX properly.

BTW, do you know who should I add to CC list for further deep review of
this code? fadevel-list?



> 
>>   struct ovl_file_entry {
>>          struct file *realfile;
>> -       void *vm_ops;
>> +       const struct vm_operations_struct *vm_ops;
>>   };
>>
>>   struct file *ovl_get_realfile(struct file *file)
>> @@ -40,14 +48,15 @@ void ovl_set_realfile(struct file *file, struct file *realfile)
>>          ofe->realfile = realfile;
>>   }
>>
>> -void *ovl_get_real_vmops(struct file *file)
>> +const struct vm_operations_struct *ovl_get_real_vmops(struct file *file)
>>   {
>>          struct ovl_file_entry *ofe = file->private_data;
>>
>>          return ofe->vm_ops;
>>   }
>>
>> -void ovl_set_real_vmops(struct file *file, void *vm_ops)
>> +void ovl_set_real_vmops(struct file *file,
>> +                       const struct vm_operations_struct *vm_ops)
>>   {
>>          struct ovl_file_entry *ofe = file->private_data;
>>
>> @@ -493,11 +502,104 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>>          return ret;
>>   }
>>
>> +vm_fault_t ovl_fault(struct vm_fault *vmf)
>> +{
>> +       struct vm_area_struct *vma = vmf->vma;
>> +       struct file *file = vma->vm_file;
>> +       struct file *realfile;
>> +       struct file *fpin, *tmp;
>> +       struct inode *inode = file_inode(file);
>> +       struct inode *realinode;
>> +       const struct cred *old_cred;
>> +       bool retry_allowed;
>> +       vm_fault_t ret;
>> +       int err = 0;
>> +
>> +       if (fault_flag_check(vmf, FAULT_FLAG_TRIED)) {
>> +               realfile = ovl_get_realfile(file);
>> +
>> +               if (!ovl_has_upperdata(inode) ||
>> +                   realfile->f_inode != ovl_inode_upper(inode) ||
>> +                   !realfile->f_op->mmap)
>> +                       return VM_FAULT_SIGBUS;
>> +
>> +               if (!ovl_get_real_vmops(file)) {
>> +                       old_cred = ovl_override_creds(inode->i_sb);
>> +                       err = call_mmap(realfile, vma);
>> +                       revert_creds(old_cred);
>> +
>> +                       vma->vm_file = file;
>> +                       if (err) {
>> +                               vma->vm_ops = &ovl_vm_ops;
>> +                               return VM_FAULT_SIGBUS;
>> +                       }
>> +                       ovl_set_real_vmops(file, vma->vm_ops);
>> +                       vma->vm_ops = &ovl_vm_ops;
>> +               }
>> +
>> +               retry_allowed = fault_flag_check(vmf, FAULT_FLAG_ALLOW_RETRY);
>> +               if (retry_allowed)
>> +                       vma->vm_flags &= ~FAULT_FLAG_ALLOW_RETRY;
>> +               vma->vm_file = realfile;
>> +               ret = ovl_get_real_vmops(file)->fault(vmf);
>> +               vma->vm_file = file;
>> +               if (retry_allowed)
>> +                       vma->vm_flags |= FAULT_FLAG_ALLOW_RETRY;
>> +               return ret;
>> +
>> +       } else {
>> +               fpin = maybe_unlock_mmap_for_io(vmf, NULL);
>> +               if (!fpin)
>> +                       return VM_FAULT_SIGBUS;
>> +
>> +               ret = VM_FAULT_RETRY;
>> +               if (!ovl_has_upperdata(inode)) {
>> +                       err = ovl_copy_up_with_data(file->f_path.dentry);
>> +                       if (err)
>> +                               goto out;
>> +               }
>> +
>> +               realinode = ovl_inode_realdata(inode);
>> +               realfile = ovl_open_realfile(file, realinode);
>> +               if (IS_ERR(realfile))
>> +                       goto out;
>> +
>> +               tmp = ovl_get_realfile(file);
>> +               ovl_set_realfile(file, realfile);
>> +               fput(tmp);
>> +
>> +out:
>> +               fput(fpin);
>> +               return ret;
>> +       }
>> +}
> 
> 
> Please add some documentation to explain the method used.
> Do we need to retry if real_vmops are already set?
> 

Good catch, actually retry is not needed in that case.

Basically, we unlock(mmap_lock)->copy-up->open when
detecting no upper inode then retry fault operation.
However, we need to check fault retry flag carefully
for avoiding endless retry.

I'll add more explanation in v2.

---
cgxu




