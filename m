MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgOvzFRb1RYSiCEE2Q4dbCCTaywi8b+kRmJOp7gUeB2-w@mail.gmail.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
	<1526379972-20923-4-git-send-email-amir73il@gmail.com>
	<CAJfpegsP-GrgenqRcc9-YrHHxWrtq1ApswD=FimUid4-8hXhBg@mail.gmail.com>
	<CAOQ4uxgOvzFRb1RYSiCEE2Q4dbCCTaywi8b+kRmJOp7gUeB2-w@mail.gmail.com>
Date: Wed, 16 May 2018 13:37:21 +0200
Message-ID: <CAJfpegukXatXsYpiMXPtUCqzNN6_yXRq2c8vyBV04fhQp2-fMA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ovl: create helper ovl_create_temp()
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, May 16, 2018 at 1:15 PM, Amir Goldstein <amir73il@gmail.com> wrote:

>>> @@ -160,6 +160,26 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
>>>         return err;
>>>  }
>>>
>>> +struct dentry *ovl_create_temp(struct dentry *workdir, struct cattr *attr,
>>> +                              struct dentry *hardlink)
>>
>> Talking of cleanups, can we put hardlink into cattr as well?  (separate patch)
>>
>
> OK. If you don't mind, I'll use this opportunity to also namespace
> it to ovl_cattr.

Good idea.

>
>>> +{
>>> +       struct inode *wdir = workdir->d_inode;
>>> +       struct dentry *temp;
>>> +       int err;
>>> +
>>> +       temp = ovl_lookup_temp(workdir);
>>> +       if (IS_ERR(temp))
>>> +               return temp;
>>
>> What's wrong with viro's version of  dentry in ovl_create_real()?
>> Turns this whole function into:
>>
>>         return ovl_create_real(d_inode(workdir),
>> ovl_lookup_temp(workdir), attr, hardlink, true);
>
> Nothing. A matter of taste. If you like Al's version better,
> I'll add it back in the next patch.

Al's version is the functional style yours is the procedural.  I think
in this particular case the functional version looks nicer.

Thanks,
Miklos
