Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:43768 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbfLFDyR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 5 Dec 2019 22:54:17 -0500
Subject: Re: [PATCH V2 0/2] ovl: implement async IO routines
References: <1574243126-59283-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <052a9b10-1cca-35d0-622a-d597421b3ecf@linux.alibaba.com>
From: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Message-ID: <7ff1ed40-ef1c-32e6-a539-1f10aa46dd42@linux.alibaba.com>
Date: Fri, 6 Dec 2019 11:54:07 +0800
MIME-Version: 1.0
In-Reply-To: <052a9b10-1cca-35d0-622a-d597421b3ecf@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
To: miklos@szeredi.hu, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

ping again.

>From my test, the patchset can improve the performance significantly.

The following data are tested on INTEL P4510 NVMe using fio with iodepth
128 and blocksize 4k.

----------------------------------------------------------------
                      |       RANDREAD     |     RANDWRITE     |
----------------------------------------------------------------
w/ async IO routines  |        377MB/s     |      405MB/s      |
----------------------------------------------------------------
w/o async IO routines |        32.0MB/s	   |      62.3MB/s     |
----------------------------------------------------------------

Regards,
Jiufei

On 2019/11/26 上午10:00, Jiufei Xue wrote:
> Hi miklos,
> 
> Could you please kindly review this patch and give some advice?
> 
> Thanks,
> Jiufei
> 
> On 2019/11/20 下午5:45, Jiufei Xue wrote:
>> ovl stacks regular file operations now. However it doesn't implement
>> async IO routines and will convert async IOs to sync IOs which is not
>> expected.
>>
>> This patchset implements overlayfs async IO routines.
>>
>> Jiufei Xue (2)
>> vfs: add vfs_iocb_iter_[read|write] helper functions
>> ovl: implement async IO routines
>>
>>  fs/overlayfs/file.c      |  116 +++++++++++++++++++++++++++++++++++++++++------
>>  fs/overlayfs/overlayfs.h |    2
>>  fs/overlayfs/super.c     |   12 ++++
>>  fs/read_write.c          |   58 +++++++++++++++++++++++
>>  include/linux/fs.h       |   16 ++++++
>>  5 files changed, 188 insertions(+), 16 deletions(-)
>>
> 
