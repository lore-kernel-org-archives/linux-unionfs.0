Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181031111038.20570-1-amir73il@gmail.com> <CAJfpegvfRu3qFCnjho0aDEL22Fs6dHAK7p9FU9n=puQ1FbGjTQ@mail.gmail.com>
 <CAOQ4uxi12LPAWdsc0zuDroRs2bx1WsRYsP3dMzv-5NOCcAYhoQ@mail.gmail.com> <20181031134723.GA20169@redhat.com>
In-Reply-To: <20181031134723.GA20169@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 31 Oct 2018 16:05:02 +0200
Message-ID: <CAOQ4uxgKDi7U1-z_KMB++WqagshEtcd0W-Q2kCAG3cXjsJNKzw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: return error on mount if metacopy cannot be enabled
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 3:47 PM Vivek Goyal <vgoyal@redhat.com> wrote:
...
>
> So "strict" will change behavior. That is where we think configuration
> is not right/suboptimal, we will fail mount?
>
> I feel little odd about enabling "strict" implicitly just because
> "metacopy" has been passed in. To me, for all new mount options,
> "strict" should be default implementation (and does not require
> strict to be on as such).
>
> For old options, users are already happy with what they are seeing
> as of now. Those who want strict behavior, they should pass in
> "strict=on" and then behavior of old knobs will change without
> breaking backward compatibility.
>

We need to think of users and documentation and real life use cases.
We need to think of overlayfs code maintenance and overlayfs developers.
We need to come up with a compromise that is the best of all worlds.

Maintaining different behavior per feature complicates the code and
IMO brings no real value to users.

If you think there is a concrete real world problem with metacopy=on
implying strict=on, please present the case.

Are you interested in making metacopy=on work on sub-optimal upper
file systems? Which one?
Are you interested in making index=on,metacopy=on fallback to
index=off,metacopy=on on underlying fs without file handle support?
Why?
What is the real life use case for which you wish to preserve those
behaviors that are mostly there because we made mistakes in the
past?

Thanks,
Amir.
