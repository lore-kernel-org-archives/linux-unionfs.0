From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [POC/RFC PATCH] overlayfs: constant inode numbers
Date: Wed, 30 Nov 2016 18:36:18 +0200
Message-ID: <CAOQ4uxgrcJxYN86zMFYU7zVofwTihJ_RkNW+1mkdS9C3zQxamQ@mail.gmail.com>
References: <20161125212934.GB2622@veci.piliscsaba.szeredi.hu>
 <CAOQ4uxgSvo_v37aLJb8FK3c5sDqCkN2XWOd783UXaomdVAvsEQ@mail.gmail.com>
 <CAOQ4uxi2Ko-G2nA_bSWT8juuss9aS9ZfiBWS95RrdfBy30Tozg@mail.gmail.com>
 <CAOQ4uxjAODFk2L7d9P+br8wOY9NW5qKH3aaRC=umBfCGPeyxkg@mail.gmail.com>
 <CAJfpegvrRF7ZS+Shx6Q8L2BsbYpX3x3UEXkPn=3oEWs2zMP+eA@mail.gmail.com>
 <CAOQ4uxgSHah2OpbgW2nrDXjwXob=_ypjz9dbmHUO-1QrfwooXg@mail.gmail.com>
 <CAJfpeguTp4AwcnouMAse1=seG=LboW68eNfRjMiEpeaBjxuYQQ@mail.gmail.com>
 <CAOQ4uxhzRkPM6aOkksMsKU1V6tdsUxhObAD938PEUPKYPp6B5Q@mail.gmail.com>
 <CAOQ4uxj2yMwY_eCdc0+6U0QP1ckm5aPw5x6xtMz+WdHvJ4bFTg@mail.gmail.com>
 <CAJfpegtRNQAebLbz2F2zV8asqt31m7Lrgc+ya28UZU1e8E1oEw@mail.gmail.com> <CAOQ4uxjX=ewaCPjTUmvyynpZAwE1g_qf-+nE05zz5OFq99f+kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxjX=ewaCPjTUmvyynpZAwE1g_qf-+nE05zz5OFq99f+kw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Nov 30, 2016 at 5:05 PM, Amir Goldstein <amir73il@gmail.com> wrote:
...
> For non-lowets entry, we can provide mount option 'readdir_ino'.
> With readdir_ino, readdir pays a penalty of getxattr for any non-lowest
> entry (either OVL_XATTR_FH or OVL_XATTR_INO).
> Without readdir_ino, readdir will get d_ino = 0, in which case, at least
> `find <path> --inum=<n>` does the right thing (fallback to fstat for
> this dirent).
>

Well, I was wrong about findutils. The -inum filter seems to fail to find
the file if d_ino is set to 0.
That's at least the case for findutils 4.4.2 that I have on debian and
4.7.0-git that I built myself.
Now I have a simple command line to use for the xfstest...

Amir.
