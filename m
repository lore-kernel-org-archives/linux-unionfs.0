Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48900 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751231AbeEQWao (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 May 2018 18:30:44 -0400
Subject: Re: [PATCH] ovl: copy up files with incompatible xattrs
References: <20180416143525.8328-1-rgoldwyn@suse.de>
 <20180517192638.GA4979@redhat.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <e02269f8-44cc-0271-8f2a-1921374bccfa@suse.de>
Date: Thu, 17 May 2018 17:30:39 -0500
MIME-Version: 1.0
In-Reply-To: <20180517192638.GA4979@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-unionfs@vger.kernel.org, Fabian Vogt <fvogt@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>



On 05/17/2018 02:26 PM, Vivek Goyal wrote:
> On Mon, Apr 16, 2018 at 09:35:25AM -0500, Goldwyn Rodrigues wrote:
>> From: Fabian Vogt <fvogt@suse.com>
>>
>> xattrs are not guarantees to be compatible across different filesystems.
>> Operations which lead to copying of files to the upper layer fail with an
>> "Operation not supported" error from the filesystem if a xattr could not be
>> written in the upper layer. We can safely ignore "system" xattrs.
>>
>> One easy to hit example is using NFS as a read-only lower layer and !NFS as
>> upper layer to store changes. Files on NFS can have the "system.nfs4_acl"
> 
> I don't know much about nfs4_acl. But name suggests that it stored ACLs
> there. So if we ignore these over copy up, does that mean we are not
> enforcing ACL policy over copy up. So say some user which was not able
> to read a file when it was on lower, might be able to read it after
> copy up?
> 
> Or I have completely misunderstood it?
> 
> 

As far as I know, all "system" attributes are filesystem specific (even
if they are the same fstype) and cannot be comprehended by other
filesystems. Hence, they can be ignored.

Unfortunately, system.nfs4_acl is a part of protocol and is null most of
the times.

Here is an earlier discussion I found which did not conclude:
https://www.spinics.net/lists/linux-nfs/msg61045.html

-- 
Goldwyn
