From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3 1/6] vfs: create vfs helper vfs_tmpfile()
Date: Thu, 9 Mar 2017 12:13:29 +0100
Message-ID: <CAJfpegsLHq8qhv+nBrgF3f0tM_LDLoOk1vTxpsdnwnc78hcppA@mail.gmail.com>
References: <1484588765-9397-1-git-send-email-amir73il@gmail.com>
 <1484588765-9397-2-git-send-email-amir73il@gmail.com> <CAJfpegsDzNot=z8oP7DecuXtNkYPYOejDWWXs6KjD6=Le=Wohg@mail.gmail.com>
 <20170219032743.GH29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170219032743.GH29622@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-unionfs@vger.kernel.org

On Sun, Feb 19, 2017 at 4:27 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Jan 16, 2017 at 08:47:32PM +0100, Miklos Szeredi wrote:
>
>> > +                          umode_t mode, int open_flag)
>> > +{
>> > +       static const struct qstr name = QSTR_INIT("/", 1);
>> > +       struct dentry *child = NULL;
>> > +       struct inode *inode;
>> > +       int error;
>> > +
>> > +       /* we want directory to be writable */
>> > +       error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
>>
>> This is not in the scope of this patch, but shoudln't we be using
>> may_create() here?   Or at least a variant without the audit thing...
>>
>> Al?
>
> may_create() expects directory + child dentry; here we have only parent.
> IS_DEADDIR is rather pointless here - directory is not locked, for
> starters, so rmdir might happen right under you.  Or right after you've
> returned from your function, for that matter.  userns checks...
> FWIW, no such checks are done in ->atomic_open() paths, so I'm not sure
> how much are those worth...

Eric would know since he added those checks.

Thanks,
Miklos
