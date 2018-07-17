Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAGr1F2EKAQ-_2BZnBMfiS=b5=R_0G0Ka6LNRZ6nRHsoQtyTFOQ@mail.gmail.com>
References: <20180712213230.157085-1-adityakali@gooogle.com>
 <CAOQ4uxj9dvgzVg3EX0q9qX6U4C-DJbs1Ph+Pj+o=8ubmYO0q8A@mail.gmail.com> <CAGr1F2EKAQ-_2BZnBMfiS=b5=R_0G0Ka6LNRZ6nRHsoQtyTFOQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 17 Jul 2018 17:42:13 +0300
Message-ID: <CAOQ4uxhi_xfzKgOs2L0ratzUG1wTcJDrxPGUR=4LV_gj6XbJfA@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: fix warning in ovl_iterate
Content-Type: text/plain; charset="UTF-8"
To: Aditya Kali <adityakali@google.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Jul 16, 2018 at 11:14 PM, Aditya Kali <adityakali@google.com> wrote:
> Hi Amir,
>
> On Fri, Jul 13, 2018 at 6:09 AM Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> On Fri, Jul 13, 2018 at 12:32 AM, Aditya Kali <adityakali@google.com> wrote:
>> > From: Aditya Kali <adityakali@google.com>
>> >
>> > In ovl_iterate() funciton, we were calling ovl_cache_get() on dentries
>> > marked OVL_IMPURE which are not refcounted. This results in triggering
>> > WARN_ON(cache->refcount <= 0).
>>
>> Aditya,
>>
>> Thanks for the report, but I am afraid your analysis is inaccurate and
>> the fix is flat out wrong, so let's try to better understand what is going on.
>>
>> First of all, the WARNING triggered by your test in WARN_ON(!cache->refcount)
>> at line 415 of  ovl_cache_get() and not the warning in ovl_cache_put().
>>
>> Your statement that dir marked OVL_IMPURE have non refcounted
>> dir cache is not accurate.
>> This statement is only true for dirs that are !ovl_dir_is_real() AND
>> marked OVL_IMPURE, in which case od->cache should be NULL
>> and therefore ovl_cache_put() is not concerned.
>>
> I completely missed that.
>
>> Since your test case hits the WARN_ON in ovl_cache_get() it suggests
>> that the dir was ovl_dir_is_real(), got a dir cache initialized with
>> ovl_cache_get_impure() and then later became !ovl_dir_is_real()
>> and got passed into  ovl_cache_get() with an unexpected type
>> of dir cache.
>>
>> Directory can only become !ovl_dir_is_real() on copy up and if dir
>> was not upper prior to copy up, it could not have been OVL_IMPURE
>> either. However, if ovl_iterate() is called with non zero ctx->pos,
>> od->is_real will not be updated, but OVL_IMPURE is checked again.
>> Meaning that if chown -R iterates on a bunch of files, chowns them
>> and then continues to iterate on more files, directory will become
>> OVL_IMPURE, so second ovl_iterate() call with non zero ctx->pos
>> will initialize an impure dir cache and then on following ls -l we will
>> hit the WARNING.
>>
>> It will be nice if you can add traces in the relevant functions to prove
>> this is what's happening in your test case.
>>
>
> Thanks for that explanation. I will admit that my knowledge about
> overlayfs is very limited.
> My initial hypothesis was based on some tracing I had added that would trigger a
>     WARN_ON(ovl_test_flag(OVL_IMPURE, d_inode(dentry))
> in ovl_cache_get() and also in ovl_cache_put().
>
> But your explanation for the root cause makes sense.
>
>> > It can be reproduced by running the following command (on system with
>> > docker using overlay2 graph driver):
>> >
>> >   docker run --rm drupal:8.5.4-fpm-alpine \
>> >     sh -c 'cd /var/www/html/vendor/symfony && chown -R www-data:www-data . && ls -l .'
>>
>> It's nice to have a one liner reproducer, but if you can come up with
>> a simple script reproducer that does not include docker that would be
>> even nicer.
>> If you write an xfstest for the reproducer you really get the praises ;-)
>>
>
> Will try to convert it to xfstests.
>

Great.
Note that I am not sure you can rely on behavior of chown -R installed on
testing host, you may need to write a dedicated C helper, like
src/t_dir_offset*.c src/t_dir_type.c
which reads a few dentries, makes sure dir is copied up and continues
to read more dentries (with non zero offset)

[...]

>
> I tested the patch and it seems to address the issue. It would be
> great if you can send the patch with clearer explanation for the root
> cause.
> You can add
> Tested-by: Aditya Kali <adityakali@google.com>
>
> Would that be ok?
>

Done.

Thanks,
Amir.
