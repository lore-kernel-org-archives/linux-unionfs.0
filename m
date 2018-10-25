MIME-Version: 1.0
In-Reply-To: <CAJfpegtGtYWbOvVZcobOO_d1OO6GhYEqE=u3OCEG2Cbsm34Eqw@mail.gmail.com>
References: <20181008042523.4134-1-amir73il@gmail.com>
	<CAJfpegtGtYWbOvVZcobOO_d1OO6GhYEqE=u3OCEG2Cbsm34Eqw@mail.gmail.com>
Date: Thu, 25 Oct 2018 14:59:52 +0200
Message-ID: <CAJfpegtGqbCMgtSHMoKNMDLjmsZeHKSTfH59vSCco491jtovTA@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: untangle copy up call chain
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 25, 2018 at 2:44 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:

>> +       temp = ovl_create_temp(c->workdir, &cattr);
>> +out:
>> +       if (new_creds) {
>> +               revert_creds(old_creds);
>
> Not new in this patch, but it looks like this will Oops if old_creds
> is NULL, which happens if security_inode_copy_up() returns an error.
>
> Trivial to fix, but I'm not sure we need the put_cred(new_creds) in
> the failed security_inode_copy_up() case.  Vivek, do you remember the
> reason for this error cleanup?

Answering myself:  this bug was introduced by a cleanup patch by me:

  7d90b853f932 ("ovl: extract helper to get temp file in copy up")

and so the put_cred() isn't needed in this case at all.

Will do a separate fix.

Thanks,
Miklos
