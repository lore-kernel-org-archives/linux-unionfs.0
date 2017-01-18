From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix possible use after free on redirect dir lookup
Date: Wed, 18 Jan 2017 06:46:03 +0200
Message-ID: <CAOQ4uxhjJC7nVxX6OBPaM6UtXUCoEFpo8h9ASyffOh5aup5XUA@mail.gmail.com>
References: <1484656498-5265-1-git-send-email-amir73il@gmail.com> <CAOQ4uxhfSbuZE2PKxMxJYhycw1YoazaGv=eebr9j4s1+CjTHgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxhfSbuZE2PKxMxJYhycw1YoazaGv=eebr9j4s1+CjTHgw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "stable [v4.9]" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Jan 17, 2017 at 10:06 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Jan 17, 2017 at 2:34 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> ovl_lookup_layer() iterates on path elements of d->name.name
>> but also frees and allocates a new pointer for d->name.name.
>>
>> For the case of lookup in upper layer, the initial d->name.name
>> pointer is stable (dentry->d_name), but for lower layers, the
>> initial d->name.name can be d->redirect, which can be freed during
>> iteration.
>>
>> Make a copy of initial d->name.name before iterating it and reset
>> the iteration pointer to point inside the newly allocated d->redirect
>> path after lookup of every element in the path.
>>
>> cc: stable [v4.9] <stable@vger.kernel.org>

And it's not 4.9 stable its 4.10 fixes of course

@stable, sorry about this noise

>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>
>> Miklos,
>>
>> I have not written a test case to prove this bug yet, just had
>> a WTF moment while working on redirect_fh.
>>
>> Am I missing something??
>>
>> Will try to add a test case to reproduce.
>>
>
> <sigh> I added some test cases and even improved the recycling infra:
> https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel
> but all I could get was a proof by adding another WARN_ON() in the code
> and print the garbage pointer.
> Breaking lookup itself proved to be harder, so I stopped trying after I got
> the evidence I needed:
>
> [  148.538035] ---[ end trace 8aa5aa8192a9dcf5 ]---
> [  148.538037] ovl_lookup_layer: next =
> 'kkkkkkkkkkkkkkkkkkkkk\xffffffa57:131', postlen = 0, name =
> '/a/dir105'
> [  148.613920] ./run --ov --ts=0 rename-move-dir
> [  148.684563] TEST rename-move-dir.py:10: Move empty dir into another
> [  148.693472] TEST rename-move-dir.py:23: Move populated dir into another
> [  148.704143] TEST rename-move-dir.py:37: Rename populated dir and
> move into another
> [  148.720317] TEST rename-move-dir.py:55: Move populated dir into
> another and rename
> [  148.735241] TEST rename-move-dir.py:73: Move populated dir into
> another and move subdir into another
> [  148.755020] TEST rename-move-dir.py:95: Rename populated dir and
> parent and move into another
>
> As a result on running ./run --ov=10 rename-move-dir with new tests
> and with the additional
> WARN_ON() and pr_err():
>
> index 9ad48d9..4ca63be 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -165,6 +165,7 @@ static int ovl_lookup_layer(struct dentry *base,
> struct ovl_lookup_data *d,
>         while (*s++ == '/' && !IS_ERR_OR_NULL(base) && d_can_lookup(base)) {
>                 const char *next = strchrnul(s, '/');
>                 size_t slen = strlen(s);
> +               size_t postlen = slen - (next - s);
>
>                 if (WARN_ON(slen > d->name.len) ||
>                     WARN_ON(strcmp(d->name.name + d->name.len - slen, s)))
> @@ -177,6 +178,11 @@ static int ovl_lookup_layer(struct dentry *base,
> struct ovl_lookup_data *d,
>                         return err;
>                 dentry = base;
>                 s = next;
> +
> +               if (WARN_ON(strlen(next) != postlen)) {
> +                       pr_err("%s: next = '%s', postlen = %ld, name =
> '%s'\n", __func__, next, postlen, d->name.name);
> +                       //return -EIO;
> +               }
>         }
>         *ret = dentry;
>         return 0;
>
>
>
>> Amir.
>>
>>  fs/overlayfs/namei.c | 33 +++++++++++++++++++++++----------
>>  1 file changed, 23 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
>> index 9ad48d9..9cb589c 100644
>> --- a/fs/overlayfs/namei.c
>> +++ b/fs/overlayfs/namei.c
>> @@ -154,6 +154,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>>  static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
>>                             struct dentry **ret)
>>  {
>> +       struct qstr name = d->name;
>>         const char *s = d->name.name;
>>         struct dentry *dentry = NULL;
>>         int err;
>> @@ -162,24 +163,36 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
>>                 return ovl_lookup_single(base, d, d->name.name, d->name.len,
>>                                          0, "", ret);
>>
>> +       /* ovl_lookup_single() -> ovl_check_redirect() may free d->name.name */
>> +       s = name.name = kstrdup(d->name.name, GFP_KERNEL);
>> +       if (!s)
>> +               return -ENOMEM;
>> +
>>         while (*s++ == '/' && !IS_ERR_OR_NULL(base) && d_can_lookup(base)) {
>> -               const char *next = strchrnul(s, '/');
>> +               const char *post = strchrnul(s, '/');
>>                 size_t slen = strlen(s);
>> +               size_t postlen = slen - (post - s);
>>
>> -               if (WARN_ON(slen > d->name.len) ||
>> -                   WARN_ON(strcmp(d->name.name + d->name.len - slen, s)))
>> -                       return -EIO;
>> -
>> -               err = ovl_lookup_single(base, d, s, next - s,
>> -                                       d->name.len - slen, next, &base);
>> +               err = ovl_lookup_single(base, d, s, post - s,
>> +                                       d->name.len - slen, post, &base);
>>                 dput(dentry);
>>                 if (err)
>> -                       return err;
>> +                       goto out_err;
>>                 dentry = base;
>> -               s = next;
>> +
>> +               /* d->name.name may be a new string with modified prefix */
>> +               s = d->name.name + d->name.len - postlen;
>> +               err = -EIO;
>> +               if (WARN_ON(postlen > name.len) ||
>> +                   WARN_ON(strcmp(name.name + name.len - postlen, s)))
>> +                       goto out_err;
>>         }
>> +
>>         *ret = dentry;
>> -       return 0;
>> +       err = 0;
>> +out_err:
>> +       kfree(name.name);
>> +       return err;
>>  }
>>
>>  /*
>> --
>> 2.7.4
>>
