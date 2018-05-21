Return-Path: <rgoldwyn@suse.de>
Subject: Re: [PATCH] ovl: copy up files with incompatible xattrs
References: <20180416143525.8328-1-rgoldwyn@suse.de>
 <20180517192638.GA4979@redhat.com>
 <e02269f8-44cc-0271-8f2a-1921374bccfa@suse.de>
 <CAJfpeguv9fFKnxwMdJq0gh+xr3jJVwDModykTOH7WyEtmVdfZg@mail.gmail.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <fefa8690-2a34-a77b-853c-c5c31cce3bc4@suse.de>
Date: Mon, 21 May 2018 13:53:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAJfpeguv9fFKnxwMdJq0gh+xr3jJVwDModykTOH7WyEtmVdfZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, Fabian Vogt <fvogt@suse.com>, Andreas Gruenbacher <agruenba@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>



On 05/18/2018 02:29 AM, Miklos Szeredi wrote:
> On Fri, May 18, 2018 at 12:30 AM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>>
>>
>> On 05/17/2018 02:26 PM, Vivek Goyal wrote:
>>> On Mon, Apr 16, 2018 at 09:35:25AM -0500, Goldwyn Rodrigues wrote:
>>>> From: Fabian Vogt <fvogt@suse.com>
>>>>
>>>> xattrs are not guarantees to be compatible across different filesystems.
>>>> Operations which lead to copying of files to the upper layer fail with an
>>>> "Operation not supported" error from the filesystem if a xattr could not be
>>>> written in the upper layer. We can safely ignore "system" xattrs.
>>>>
>>>> One easy to hit example is using NFS as a read-only lower layer and !NFS as
>>>> upper layer to store changes. Files on NFS can have the "system.nfs4_acl"
>>>
>>> I don't know much about nfs4_acl. But name suggests that it stored ACLs
>>> there. So if we ignore these over copy up, does that mean we are not
>>> enforcing ACL policy over copy up. So say some user which was not able
>>> to read a file when it was on lower, might be able to read it after
>>> copy up?
>>>
>>> Or I have completely misunderstood it?
>>>
>>>
>>
>> As far as I know, all "system" attributes are filesystem specific (even
>> if they are the same fstype) and cannot be comprehended by other
>> filesystems. Hence, they can be ignored.
>>
>> Unfortunately, system.nfs4_acl is a part of protocol and is null most of
>> the times.
>>
>> Here is an earlier discussion I found which did not conclude:
>> https://www.spinics.net/lists/linux-nfs/msg61045.html
> 
> It did have a conclusion, except nobody done anything in that direction:
> 
> In certain cases nfs4_acl represents the same permissions as file
> mode.  This case can be detected and the nfs4_acl xattr ignored.
> 
> As a first step that's definitely something that could help in most
> cases.  I'd be reluctant to just ignore copy up errors on system
> xattrs generally.

It seems nfs4_acl is only interpreted by the server and not the client.
nfs4_acl is carried opaque by the client and decoded only in the
userspace by nfs4-acl-tools. Not sure if there is a simpler way to do it
than to copy code from knfsd to client (or use common codebase, if exists).


-- 
Goldwyn
