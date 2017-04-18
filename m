From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 03/13] ovl: lookup redirect by file handle
Date: Tue, 18 Apr 2017 17:05:12 +0300
Message-ID: <CAOQ4uxi2a3K-a2A2RghSsJxf7QEP8Mcb4P_dyygYq=eggAi8SQ@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <1492387183-18847-4-git-send-email-amir73il@gmail.com> <20170418130554.GB9056@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170418130554.GB9056@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Apr 18, 2017 at 4:05 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Apr 17, 2017 at 02:59:33AM +0300, Amir Goldstein wrote:
>
> [..]
>> @@ -272,6 +385,33 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>>                       goto out_put_upper;
>>       }
>>
>> +     /* Try to lookup lower layers by file handle (at root) */
>> +     d.by_path = false;
>> +     for (i = 0; !d.stop && d.fh && i < roe->numlower; i++) {
>> +             struct path lowerpath = roe->lowerstack[i];
>> +
>> +             d.last = i == roe->numlower - 1;
>> +             err = ovl_lookup_layer_fh(&lowerpath, &d, &this);
>> +             if (err)
>> +                     goto out_put;
>> +
>> +             if (!this)
>> +                     continue;
>> +
>> +             stack[ctr].dentry = this;
>> +             stack[ctr].mnt = lowerpath.mnt;
>> +             ctr++;
>> +     }
>> +
>> +     /* Fallback to lookup lower layers by name (at parent) */
>> +     if (ctr) {
>> +             d.stop = true;
>
> Hi Amir,
>
> Got a very basic question. So say I two lower layers and a directory is
> in present in both, say lower1/dir1 and lower2/dir1. Now this directory
> gets copied up to upper/dir1. Assume lower1/dir1 is being copied up. So
> upper/dir1 will save file handle of lower1/dir1 right? This file handle
> does not represent lower2/dir1?
>
> IOW, later when I am doing lookup, then using file handle I will find
> dentry of lower1/dir1 but not lower2/dir1. And looks like we will not
> path based lookup as ctr will be non-zero (as we found one dentry in
> one path).
>
> What am I missing.
>

You are not missing anything - I am.

The reason I did not bump into this is because I have only 2 testing modes
with unionmount testsuite:
- upper layers recycled to lower layers without redirect fh (./run --ov=N)
- upper layers recycled to lower layers with redirect fh (./run --ov=N --samefs)

I have no tests that compose lower layers without redirect_fh and
upper layer with redirect_fh.
So in my tests, lower1/dir1 will always have a redirect_fh to lower2/dir1.

One way I consider adressing this issue is:
When mounting redirect_fh, check that all lowerstack[i] has a redirect_fh
to lowerstack[i+1] and set a redirect_fh to lowerstack[0] from upperdir.
If any of the redirect_fh are missing or stale (because lowerdirs were copied)
disable redirect_fh.

I think that any attempt to fallback from lookup by fh to lookup by path
is going to be risky and I wish to eliminate the per lookup fallback.
When redirect_fh does not fallback to lookup by path, then the semantics
of "implicit opaque" are always correct and there is no longer a need to
check directories for opaque xattr explicitly (the lack of redirect fh xattr
means opaque).

> (This ovl_lookup() logic has become really twisted now. I wished it was
>  little easier to read.)
>

Me too. IMO, most of the complexity is in the fallbacks from redirect
by fh to full path to relative path. Eliminating some of these fallbacks
and maybe having separate lookup op per mode, may simplify the code.

Amir.
