Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx144.netapp.com ([216.240.21.25]:2323 "EHLO mx144.netapp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756765AbeEJKy7 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 May 2018 06:54:59 -0400
Subject: Re: [PATCH v2 0/4] Enable holes in copy_file_range()
References: <20180510015820.17700-1-rgoldwyn@suse.de>
 <CAOQ4uxiDi9fFGhXxWH-pvDDP-8rk9cmwedLcsid3L51KyP8fbA@mail.gmail.com>
From: Anna Schumaker <Anna.Schumaker@Netapp.com>
Message-ID: <7c2bce28-9e55-f9bc-0212-bbd26b56a036@Netapp.com>
Date: Thu, 10 May 2018 06:45:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxiDi9fFGhXxWH-pvDDP-8rk9cmwedLcsid3L51KyP8fbA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, overlayfs <linux-unionfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-unionfs@vger.kernel.org>



On 05/10/2018 12:47 AM, Amir Goldstein wrote:
> On Thu, May 10, 2018 at 4:58 AM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>> If copy_file_range performs a copy using splice, it converts holes
>> to zeros. This effort primarily changes this behavior to create
>> holes when it is possible.
>>
>> Even if copy_file_range() or clone_file_range() does not work for different
>> mounted filesystems, We should be able to splice files if they do not
>> belong the same super_block.
>>
>> Changes since v1:
>> - Fixed bug when hole/data offset is farther than len
> 
> Please specify how you tested this work.
> Did you run the xfstests generic/copy tests that Anna wrote?
> If the tests caught your bugs - good, if they didn't, please
> write more tests to cover the issues you found.
> One thing I do not see in the existing tests is coverage for the
> trivial case of "only holes" (i.e. touch x; truncate -s 10 x).

Yeah,  that's probably an oversight on my part.  I hadn't even thought about sparse files as I was writing those tests.  Please add tests for holes!

Anna

> 
> Thanks,
> Amir.
> 
